/**
 * Point d'entrée des Cloud Functions.
 *
 * À ce stade (v0.1) : exports minimaux. Les triggers Firestore et les
 * callables seront branchés au moment où la couche data est connectée
 * côté app (cf. docs/architecture/cloud-functions.md).
 */

import { setGlobalOptions } from "firebase-functions/v2";

setGlobalOptions({ region: "europe-west1", maxInstances: 10 });

export { moderateReport } from "./moderation";
export { buildAggregate } from "./aggregates";
