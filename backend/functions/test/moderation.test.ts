import {
  containsNominativeMention,
  isWithinReportingWindow,
  moderateReport,
  type ReportFields,
} from "../src/moderation";

describe("containsNominativeMention", () => {
  it("detects civility followed by a name", () => {
    expect(containsNominativeMention("Madame Dupont est absente")).toBe(true);
    expect(containsNominativeMention("M. Martin")).toBe(true);
  });

  it("detects role followed by a capitalised name", () => {
    expect(containsNominativeMention("le prof Bernard")).toBe(true);
  });

  it("ignores neutral wording", () => {
    expect(containsNominativeMention("le professeur de maths")).toBe(false);
    expect(containsNominativeMention("")).toBe(false);
  });
});

describe("isWithinReportingWindow", () => {
  const now = new Date("2026-04-25T09:00:00Z");

  it("rejects future dates", () => {
    const future = new Date("2026-04-26T09:00:00Z");
    expect(isWithinReportingWindow(future, now)).toBe(false);
  });

  it("accepts a date within the window", () => {
    const recent = new Date("2026-04-15T09:00:00Z");
    expect(isWithinReportingWindow(recent, now)).toBe(true);
  });

  it("rejects a date older than the window", () => {
    const old = new Date("2026-03-01T09:00:00Z");
    expect(isWithinReportingWindow(old, now)).toBe(false);
  });
});

describe("moderateReport", () => {
  const now = new Date("2026-04-25T09:00:00Z");

  const baseTeacher: ReportFields = {
    agentType: "teacher",
    schoolStage: "college",
    level: "4e",
    discipline: "maths",
    date: new Date("2026-04-22T09:00:00Z"),
    durationHours: 1,
  };

  it("accepts a complete secondary teacher report", () => {
    expect(moderateReport(baseTeacher, now)).toBe("ok");
  });

  it("requires discipline at college", () => {
    expect(
      moderateReport({ ...baseTeacher, discipline: null }, now),
    ).toBe("missing_discipline");
  });

  it("does not require discipline at primary", () => {
    expect(
      moderateReport(
        {
          ...baseTeacher,
          schoolStage: "elementaire",
          level: "cm2",
          discipline: null,
        },
        now,
      ),
    ).toBe("ok");
  });

  it("rejects out-of-window date", () => {
    expect(
      moderateReport(
        { ...baseTeacher, date: new Date("2026-02-01T09:00:00Z") },
        now,
      ),
    ).toBe("out_of_window");
  });

  it("rejects nominative comment", () => {
    expect(
      moderateReport({ ...baseTeacher, comment: "Madame Dupont absente" }, now),
    ).toBe("nominative");
  });
});
