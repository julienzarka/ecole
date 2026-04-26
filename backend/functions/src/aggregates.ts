/**
 * Calcul d'agrégats à partir des reports validés. Réellement appelé
 * par le scheduler `recomputeAggregates` (cf. cloud-functions.md).
 *
 * Note : k-anonymat respecté — si une maille n'atteint pas le seuil
 * (≥ 3 reports validés ET ≥ 2 parents distincts), `kAnonymitySatisfied=false`
 * et le client masque les chiffres.
 */

export const K_MIN_REPORTS = 3;
export const K_MIN_REPORTERS = 2;

export interface ValidatedReportRow {
  schoolId: string;
  reporterUid: string;
  agentType: string;
  schoolStage: string;
  discipline: string | null;
  durationHours: number;
  replaced: boolean | null;
}

export interface Aggregate {
  hoursLost: number;
  reportsCount: number;
  reportersCount: number;
  byAgentType: Record<string, number>;
  byStage: Record<string, number>;
  byDiscipline: Record<string, number>;
  replacementRate: number;
  topSchools: Array<{ uai: string; hoursLost: number }>;
  kAnonymitySatisfied: boolean;
}

export function buildAggregate(rows: ValidatedReportRow[]): Aggregate {
  const reportersCount = new Set(rows.map((r) => r.reporterUid)).size;
  const reportsCount = rows.length;
  const hoursLost = rows.reduce((sum, r) => sum + r.durationHours, 0);

  const byAgentType: Record<string, number> = {};
  const byStage: Record<string, number> = {};
  const byDiscipline: Record<string, number> = {};
  for (const r of rows) {
    byAgentType[r.agentType] =
      (byAgentType[r.agentType] ?? 0) + r.durationHours;
    byStage[r.schoolStage] =
      (byStage[r.schoolStage] ?? 0) + r.durationHours;
    if (r.discipline) {
      byDiscipline[r.discipline] =
        (byDiscipline[r.discipline] ?? 0) + r.durationHours;
    }
  }

  const replacedCount = rows.filter((r) => r.replaced === true).length;
  const knownReplacementCount = rows.filter(
    (r) => r.replaced === true || r.replaced === false,
  ).length;
  const replacementRate =
    knownReplacementCount === 0 ? 0 : replacedCount / knownReplacementCount;

  const perSchool: Record<string, number> = {};
  for (const r of rows) {
    perSchool[r.schoolId] = (perSchool[r.schoolId] ?? 0) + r.durationHours;
  }
  const topSchools = Object.entries(perSchool)
    .map(([uai, h]) => ({ uai, hoursLost: h }))
    .sort((a, b) => b.hoursLost - a.hoursLost)
    .slice(0, 10);

  return {
    hoursLost,
    reportsCount,
    reportersCount,
    byAgentType,
    byStage,
    byDiscipline,
    replacementRate,
    topSchools,
    kAnonymitySatisfied:
      reportsCount >= K_MIN_REPORTS && reportersCount >= K_MIN_REPORTERS,
  };
}
