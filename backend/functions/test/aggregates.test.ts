import { K_MIN_REPORTERS, K_MIN_REPORTS, buildAggregate } from "../src/aggregates";

describe("buildAggregate", () => {
  it("returns zeroed aggregate when empty", () => {
    const agg = buildAggregate([]);
    expect(agg.hoursLost).toBe(0);
    expect(agg.reportsCount).toBe(0);
    expect(agg.reportersCount).toBe(0);
    expect(agg.kAnonymitySatisfied).toBe(false);
  });

  it("flags k-anonymity when both thresholds are met", () => {
    const agg = buildAggregate([
      {
        schoolId: "0750001A",
        reporterUid: "u1",
        agentType: "teacher",
        schoolStage: "college",
        discipline: "maths",
        durationHours: 1,
        replaced: false,
      },
      {
        schoolId: "0750001A",
        reporterUid: "u2",
        agentType: "teacher",
        schoolStage: "college",
        discipline: "maths",
        durationHours: 2,
        replaced: false,
      },
      {
        schoolId: "0750001A",
        reporterUid: "u3",
        agentType: "aesh",
        schoolStage: "college",
        discipline: null,
        durationHours: 4,
        replaced: true,
      },
    ]);

    expect(agg.reportsCount).toBe(K_MIN_REPORTS);
    expect(agg.reportersCount).toBe(K_MIN_REPORTERS + 1);
    expect(agg.kAnonymitySatisfied).toBe(true);
    expect(agg.hoursLost).toBeCloseTo(7);
    expect(agg.byAgentType.teacher).toBeCloseTo(3);
    expect(agg.byAgentType.aesh).toBeCloseTo(4);
    expect(agg.byDiscipline.maths).toBeCloseTo(3);
    expect(agg.replacementRate).toBeCloseTo(1 / 3);
    expect(agg.topSchools[0]).toEqual({ uai: "0750001A", hoursLost: 7 });
  });

  it("does not satisfy k-anonymity with a single reporter", () => {
    const agg = buildAggregate([
      {
        schoolId: "0750001A",
        reporterUid: "u1",
        agentType: "teacher",
        schoolStage: "college",
        discipline: "maths",
        durationHours: 1,
        replaced: false,
      },
      {
        schoolId: "0750001A",
        reporterUid: "u1",
        agentType: "teacher",
        schoolStage: "college",
        discipline: "maths",
        durationHours: 1,
        replaced: false,
      },
      {
        schoolId: "0750001A",
        reporterUid: "u1",
        agentType: "teacher",
        schoolStage: "college",
        discipline: "maths",
        durationHours: 1,
        replaced: false,
      },
    ]);
    expect(agg.kAnonymitySatisfied).toBe(false);
  });
});
