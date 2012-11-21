function [] = test( outputPath, batchFilePrefix )

addpath toolbox/;

t = load(sprintf('%s/params_final.mat', outputPath), 'theta', 'trainParams');

% Additional options
disp('Loading test images');
batchFilePath   = 'image_data/cifar-10-features';
[imgs, categories, originalCategoryNames] = loadTrainBatch(batchFilePrefix, batchFilePath);

%% Load word representations
disp('Loading word representations');
ee = load(['word_data/' t.trainParams.wordDataset '/embeddings.mat']);
vv = load(['word_data/' t.trainParams.wordDataset '/vocab.mat']);
testCategoryNames = loadCategoryNames({ 'truck' });
t.trainParams.embeddingSize = size(ee.embeddings, 1);
wordTable = zeros(t.trainParams.embeddingSize, length(testCategoryNames));
for categoryIndex = 1:length(testCategoryNames)
    icategoryWord = ismember(vv.vocab, testCategoryNames(categoryIndex)) == true;
    wordTable(:, categoryIndex) = ee.embeddings(:, icategoryWord);
end
clear ee vv f;

disp('Test results');
doEvaluate(imgs, categories, originalCategoryNames, testCategoryNames, wordTable, t.theta, t.trainParams);

end