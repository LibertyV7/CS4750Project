ALTER TABLE Debate
ADD CONSTRAINT chk_debateType CHECK (debateType IN ('Humorous', 'Serious'));

ALTER TABLE Debate
DROP COLUMN qualityOverall;

ALTER TABLE Debate
DROP COLUMN sentimentOverall;

ALTER TABLE Debate
ADD COLUMN qualityOverall VARCHAR(10);

ALTER TABLE Debate
ADD CONSTRAINT chk_qualityOverall CHECK(qualityOverall IN ('Government', 'Opposition'));

ALTER TABLE Debate
ADD COLUMN sentimentOverall VARCHAR(10);

ALTER TABLE Debate
ADD CONSTRAINT chk_sentimentOverall CHECK(sentimentOverall IN ('In Favor', 'Against'));
