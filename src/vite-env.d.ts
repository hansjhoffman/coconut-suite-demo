/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_EMBED_ID: string;
  readonly VITE_PRIVATE_KEY: string;
  readonly VITE_USER_EMAIL: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
