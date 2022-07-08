import { flatfileImporter } from "@flatfile/sdk";
import * as IO from "fp-ts/IO";
import { match } from "ts-pattern";

import { Elm } from "./Main.elm";
import "./globals.css";
import "./devs";

/*
 * Types
 */

interface BatchData {
  batchId: string;
  data: () => Promise<unknown>;
}

/*
 * Main
 */

const importer = flatfileImporter("");

await importer.__unsafeGenerateToken({
  privateKey: import.meta.env.VITE_PRIVATE_KEY,
  embedId: import.meta.env.VITE_EMBED_ID,
  endUserEmail: "foo@bar.com",
});

const openFileImporter = (): IO.IO<void> => () => {
  importer.launch();
};

importer.on("init", ({ batchId }): void => {
  console.log(
    "%c" + `⥤ Batch ${batchId} has been initialized.`,
    "background-color: #4a3fd2; padding: 4px;",
  );
});

importer.on("launch", ({ batchId }): void => {
  console.log(
    "%c" + `⥤ Batch ${batchId} has been launched.`,
    "background-color: #4a3fd2; padding: 4px;",
  );
});

importer.on("error", (error: unknown): void => {
  console.error("%c" + `⥤ ${error}`, "color: red; padding: 4px;");
});

importer.on("complete", async (payload: BatchData): Promise<void> => {
  const data = await payload.data();
  const serialized: string = JSON.stringify(data, null, 4);

  console.group("%c" + "⥤ SDK Output: 👇", "background-color: #4a3fd2; padding: 4px;");
  console.log("%c" + serialized, "background-color: #4a3fd2; padding: 4px;");
});

const app = Elm.Main.init({
  node: document.querySelector<HTMLDivElement>("app"),
  flags: null,
});

app.ports.interopFromElm.subscribe((fromElm) => {
  return match(fromElm)
    .with({ tag: "flatFileImporter" }, () => {
      openFileImporter()();
    })
    .exhaustive();
});

app.ports.interopFromElm.unsubscribe((fromElm) => {
  return match(fromElm)
    .with({ tag: "flatFileImporter" }, () => {
      // do nothing
    })
    .exhaustive();
});
