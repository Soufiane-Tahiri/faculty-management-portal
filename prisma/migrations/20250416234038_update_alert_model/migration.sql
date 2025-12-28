/*
  Warnings:

  - You are about to drop the column `message` on the `Alert` table. All the data in the column will be lost.
  - Added the required column `description` to the `Alert` table without a default value. This is not possible if the table is not empty.
  - Added the required column `title` to the `Alert` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `type` on the `Alert` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "AlertType" AS ENUM ('error', 'warning', 'info');

-- AlterTable
ALTER TABLE "Alert" DROP COLUMN "message",
ADD COLUMN     "description" TEXT NOT NULL,
ADD COLUMN     "title" TEXT NOT NULL,
ADD COLUMN     "userId" INTEGER,
DROP COLUMN "type",
ADD COLUMN     "type" "AlertType" NOT NULL;

-- AddForeignKey
ALTER TABLE "Alert" ADD CONSTRAINT "Alert_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
