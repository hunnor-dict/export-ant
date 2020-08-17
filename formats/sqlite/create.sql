CREATE TABLE "content" (
  "id" INTEGER,
  "language" TEXT,
  "pos" TEXT,
  "dictForms" TEXT,
  "homonyms" TEXT,
  "inflectionLabels" TEXT,
  "inflectedForms" TEXT,
  "translation" TEXT
);

CREATE TABLE "forms" (
  "id" INTEGER,
  "language" TEXT,
  "inflected" INTEGER,
  "form" TEXT,
  "form_normalized" TEXT,
  "label" TEXT,
  "n" INTEGER,
  "homonym" INTEGER,
  "sort" TEXT
);
