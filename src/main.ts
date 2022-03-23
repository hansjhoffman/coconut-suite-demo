import { flatfileImporter } from "@flatfile/sdk";
import * as IO from "fp-ts/IO";
import { match } from "ts-pattern";

import { Elm } from "./Main.elm";
import "./style.css";

const importer = flatfileImporter("");

await importer.__unsafeGenerateToken({
  privateKey: import.meta.env.VITE_PRIVATE_KEY,
  embedId: import.meta.env.VITE_EMBED_ID,
  endUserEmail: import.meta.env.VITE_USER_EMAIL,
});

const openFileImporter = (): IO.IO<void> => () => {
  importer.launch();
};

importer.on("init", ({ batchId }) => {
  console.log(`Batch ${batchId} has been initialized.`);
});

importer.on("launch", ({ batchId }) => {
  console.log(`Batch ${batchId} has been launched.`);
});

importer.on("error", (error) => {
  console.error(error);
});

importer.on("complete", async (payload) => {
  console.log(JSON.stringify(await payload.data(), null, 4));
});

const app = Elm.Main.init({
  node: document.getElementById("app"),
  flags: null,
});

app.ports.interopFromElm.subscribe((fromElm) => {
  return match(fromElm)
    .with({ tag: "flatFileImporter" }, () => openFileImporter()())
    .exhaustive();
});