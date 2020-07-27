CREATE TABLE "content" (
  "id" INTEGER,
  "language" TEXT,
  "pos" TEXT,
  "dictForms" TEXT,
  "homonyms" TEXT,
  "inflectionLabels" TEXT,
  "inflectedForms" TEXT,
  "translation" TEXT,
  "sort" TEXT
);

CREATE TABLE "forms" (
  "id" INTEGER,
  "language" TEXT,
  "form" TEXT,
  "inflected" INTEGER
);
