/**
 * Modération côté serveur : checks effectués par `onReportCreate`.
 * Cf. docs/specs/rgpd.md (interdiction texte libre, fenêtre 30 j).
 */

export const REPORT_WINDOW_DAYS = 30;
export const REPORT_MAX_DURATION_HOURS = 8;

const NAME_HINT_REGEX = /\b(monsieur|madame|m\.|mme|mlle)\s+[a-zàâçéèêëîïôûùüÿñæœ]{3,}/i;
const TITLE_NAME_REGEX = /\b(prof|enseignante?|aesh|atsem|cpe|aed)\s+[A-ZÀÂÇÉÈÊËÎÏÔÛÙÜŸÑÆŒ][a-zàâçéèêëîïôûùüÿñæœ]+/;

export function containsNominativeMention(input: string): boolean {
  if (!input) {
    return false;
  }
  return NAME_HINT_REGEX.test(input) || TITLE_NAME_REGEX.test(input);
}

export function isWithinReportingWindow(
  reportDate: Date,
  now: Date = new Date(),
  windowDays: number = REPORT_WINDOW_DAYS,
): boolean {
  if (reportDate > now) {
    return false;
  }
  const deltaMs = now.getTime() - reportDate.getTime();
  const deltaDays = deltaMs / (1000 * 60 * 60 * 24);
  return deltaDays <= windowDays;
}

export function isValidDuration(durationHours: number): boolean {
  return (
    Number.isFinite(durationHours) &&
    durationHours > 0 &&
    durationHours <= REPORT_MAX_DURATION_HOURS
  );
}

export type ReportStage = "maternelle" | "elementaire" | "college" | "lycee";
export type ReportAgentType =
  | "teacher"
  | "aesh"
  | "atsem"
  | "animator"
  | "aed"
  | "cpe"
  | "cantine"
  | "garderie"
  | "etude";

export interface ReportFields {
  agentType: ReportAgentType;
  schoolStage: ReportStage;
  level: string | null;
  discipline: string | null;
  date: Date;
  durationHours: number;
  comment?: string;
}

export type ModerationCode =
  | "ok"
  | "out_of_window"
  | "invalid_duration"
  | "missing_level"
  | "missing_discipline"
  | "nominative";

export function moderateReport(
  fields: ReportFields,
  now: Date = new Date(),
): ModerationCode {
  if (!isWithinReportingWindow(fields.date, now)) {
    return "out_of_window";
  }
  if (!isValidDuration(fields.durationHours)) {
    return "invalid_duration";
  }
  if (fields.agentType === "teacher" && !fields.level) {
    return "missing_level";
  }
  if (
    fields.agentType === "teacher" &&
    (fields.schoolStage === "college" || fields.schoolStage === "lycee") &&
    !fields.discipline
  ) {
    return "missing_discipline";
  }
  if (fields.comment && containsNominativeMention(fields.comment)) {
    return "nominative";
  }
  return "ok";
}
