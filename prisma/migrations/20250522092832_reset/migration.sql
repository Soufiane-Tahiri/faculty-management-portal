-- CreateEnum
CREATE TYPE "RequestType" AS ENUM ('adduser', 'deleteuser', 'updateuser', 'register', 'announcement');

-- CreateEnum
CREATE TYPE "RequestStatus" AS ENUM ('pending', 'dean_approved', 'dean_rejected', 'admin_approved', 'admin_rejected');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('PENDING', 'ACTIVE', 'REJECTED');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "department" TEXT,
ADD COLUMN     "personneId" INTEGER,
ADD COLUMN     "resetToken" TEXT,
ADD COLUMN     "resetTokenExpiry" TIMESTAMP(3),
ADD COLUMN     "status" "UserStatus" NOT NULL DEFAULT 'PENDING';

-- CreateTable
CREATE TABLE "requests" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "userId" INTEGER,
    "type" "RequestType" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "RequestStatus" NOT NULL,
    "department" TEXT,
    "status_user" "UserStatus" NOT NULL DEFAULT 'PENDING',
    "status_doyen" "RequestStatus" NOT NULL DEFAULT 'pending',
    "status_admin" "RequestStatus" NOT NULL DEFAULT 'pending',
    "userData" JSONB,
    "personData" JSONB,

    CONSTRAINT "requests_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "personnes" (
    "idp" SERIAL NOT NULL,
    "nom" VARCHAR(100) NOT NULL,
    "prenom" VARCHAR(100) NOT NULL,
    "cin" VARCHAR(50),
    "adr" VARCHAR(255),
    "ville" VARCHAR(100),
    "date_nai" DATE,
    "email" VARCHAR(100),
    "tele" VARCHAR(20),
    "photo" BYTEA,

    CONSTRAINT "personnes_pkey" PRIMARY KEY ("idp")
);

-- CreateTable
CREATE TABLE "etudiants" (
    "idp" INTEGER NOT NULL,
    "cne" VARCHAR(50),
    "niveau" VARCHAR(50),
    "date_insc" DATE,
    "statut" VARCHAR(50),

    CONSTRAINT "etudiants_pkey" PRIMARY KEY ("idp")
);

-- CreateTable
CREATE TABLE "date_val" (
    "id" SERIAL NOT NULL,
    "date_val" DATE,
    "moyenne" DECIMAL(5,2),
    "mention" VARCHAR(50),
    "idp" INTEGER,
    "codem" VARCHAR(20),

    CONSTRAINT "date_val_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "annonces" (
    "ida" SERIAL NOT NULL,
    "titre" VARCHAR(100) NOT NULL,
    "contenu" TEXT,
    "date_pub" DATE,
    "deg_imp" INTEGER,

    CONSTRAINT "annonces_pkey" PRIMARY KEY ("ida")
);

-- CreateTable
CREATE TABLE "personne_annonce" (
    "idp" INTEGER NOT NULL,
    "ida" INTEGER NOT NULL,
    "date_proposition" DATE,

    CONSTRAINT "personne_annonce_pkey" PRIMARY KEY ("idp","ida")
);

-- CreateTable
CREATE TABLE "departements" (
    "coded" VARCHAR(20) NOT NULL,
    "nom" VARCHAR(100),
    "description" TEXT,
    "date_creat" DATE,
    "codee" VARCHAR(20),

    CONSTRAINT "departements_pkey" PRIMARY KEY ("coded")
);

-- CreateTable
CREATE TABLE "personne_departement" (
    "idp" INTEGER NOT NULL,
    "coded" VARCHAR(20) NOT NULL,

    CONSTRAINT "personne_departement_pkey" PRIMARY KEY ("idp","coded")
);

-- CreateTable
CREATE TABLE "documents" (
    "iddoc" SERIAL NOT NULL,
    "titre" VARCHAR(100) NOT NULL,
    "type" VARCHAR(50),
    "chemin" VARCHAR(255),
    "date_creat" DATE,
    "version" VARCHAR(20),
    "niveau_confid" INTEGER,

    CONSTRAINT "documents_pkey" PRIMARY KEY ("iddoc")
);

-- CreateTable
CREATE TABLE "personne_document" (
    "idp" INTEGER NOT NULL,
    "iddoc" INTEGER NOT NULL,
    "date_publication" DATE,
    "idetud" INTEGER,
    "idpersonnel" INTEGER,

    CONSTRAINT "personne_document_pkey" PRIMARY KEY ("idp","iddoc")
);

-- CreateTable
CREATE TABLE "document_templates" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "document_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "personnels" (
    "idpersonnel" SERIAL NOT NULL,
    "fonction" VARCHAR(100),
    "specialite" VARCHAR(100),
    "idp" INTEGER NOT NULL,

    CONSTRAINT "personnels_pkey" PRIMARY KEY ("idpersonnel")
);

-- CreateTable
CREATE TABLE "personne_role" (
    "idp" INTEGER NOT NULL,
    "role" VARCHAR(50) NOT NULL,

    CONSTRAINT "personne_role_pkey" PRIMARY KEY ("idp","role")
);

-- CreateTable
CREATE TABLE "etablissements" (
    "codee" VARCHAR(20) NOT NULL,
    "nom" VARCHAR(100) NOT NULL,
    "adresse" VARCHAR(255),
    "ville" VARCHAR(100),
    "code_postal" VARCHAR(20),

    CONSTRAINT "etablissements_pkey" PRIMARY KEY ("codee")
);

-- CreateTable
CREATE TABLE "filieres" (
    "codef" VARCHAR(20) NOT NULL,
    "niveau" VARCHAR(50),
    "duree" INTEGER,
    "intitule" VARCHAR(100),
    "coded" VARCHAR(20),

    CONSTRAINT "filieres_pkey" PRIMARY KEY ("codef")
);

-- CreateTable
CREATE TABLE "modules" (
    "codem" VARCHAR(20) NOT NULL,
    "intitule" VARCHAR(100),
    "volumeh" INTEGER,
    "semester" INTEGER,

    CONSTRAINT "modules_pkey" PRIMARY KEY ("codem")
);

-- CreateTable
CREATE TABLE "filiere_module" (
    "codef" VARCHAR(20) NOT NULL,
    "codem" VARCHAR(20) NOT NULL,

    CONSTRAINT "filiere_module_pkey" PRIMARY KEY ("codef","codem")
);

-- CreateIndex
CREATE UNIQUE INDEX "cin" ON "personnes"("cin");

-- CreateIndex
CREATE UNIQUE INDEX "email" ON "personnes"("email");

-- CreateIndex
CREATE UNIQUE INDEX "cne" ON "etudiants"("cne");

-- CreateIndex
CREATE UNIQUE INDEX "personnels_idp_key" ON "personnels"("idp");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_personneId_fkey" FOREIGN KEY ("personneId") REFERENCES "personnes"("idp") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "requests" ADD CONSTRAINT "requests_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "etudiants" ADD CONSTRAINT "etudiants_idp_fkey" FOREIGN KEY ("idp") REFERENCES "personnes"("idp") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "date_val" ADD CONSTRAINT "date_val_idp_fkey" FOREIGN KEY ("idp") REFERENCES "etudiants"("idp") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "personne_annonce" ADD CONSTRAINT "personne_annonce_ida_fkey" FOREIGN KEY ("ida") REFERENCES "annonces"("ida") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "personne_annonce" ADD CONSTRAINT "personne_annonce_idp_fkey" FOREIGN KEY ("idp") REFERENCES "personnes"("idp") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "departements" ADD CONSTRAINT "departements_codee_fkey" FOREIGN KEY ("codee") REFERENCES "etablissements"("codee") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "personne_departement" ADD CONSTRAINT "personne_departement_coded_fkey" FOREIGN KEY ("coded") REFERENCES "departements"("coded") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "personne_departement" ADD CONSTRAINT "personne_departement_idp_fkey" FOREIGN KEY ("idp") REFERENCES "personnes"("idp") ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "personne_document" ADD CONSTRAINT "personne_document_iddoc_fkey" FOREIGN KEY ("iddoc") REFERENCES "documents"("iddoc") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "personne_document" ADD CONSTRAINT "personne_document_idp_fkey" FOREIGN KEY ("idp") REFERENCES "personnes"("idp") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "personne_document" ADD CONSTRAINT "personne_document_idetud_fkey" FOREIGN KEY ("idetud") REFERENCES "etudiants"("idp") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "personne_document" ADD CONSTRAINT "personne_document_idpersonnel_fkey" FOREIGN KEY ("idpersonnel") REFERENCES "personnels"("idpersonnel") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "personnels" ADD CONSTRAINT "personnels_idp_fkey" FOREIGN KEY ("idp") REFERENCES "personnes"("idp") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "personne_role" ADD CONSTRAINT "personne_role_idp_fkey" FOREIGN KEY ("idp") REFERENCES "personnes"("idp") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "filieres" ADD CONSTRAINT "filieres_coded_fkey" FOREIGN KEY ("coded") REFERENCES "departements"("coded") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "filiere_module" ADD CONSTRAINT "filiere_module_codef_fkey" FOREIGN KEY ("codef") REFERENCES "filieres"("codef") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "filiere_module" ADD CONSTRAINT "filiere_module_codem_fkey" FOREIGN KEY ("codem") REFERENCES "modules"("codem") ON DELETE RESTRICT ON UPDATE CASCADE;
