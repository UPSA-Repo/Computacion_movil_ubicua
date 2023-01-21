using Azure;
using Azure.AI.TextAnalytics;
using LanguageCS;

var client = new TextAnalyticsClient(new Uri(Secrets.apiEndpoint), new AzureKeyCredential(Secrets.secretEndpoint));

List<string> usernames = new List<string>();
List<string> comments = new List<string>();
string pathCSV = Secrets.pathCSV;

Console.WriteLine("Initializing...");

using ( var reader = new StreamReader(pathCSV))
{
    while(!reader.EndOfStream)
    {
        string line = reader.ReadLine()!;
        var values = line.Split(';');

        usernames.Add(values[0]);
        comments.Add(values[1]);
    }
    reader.Close();
}

List<TextDocumentInput> documents = new List<TextDocumentInput>();
for(int i= 0; i < comments.Count; i++)
{
    documents.Add( new TextDocumentInput($"{i+1}", comments[i]) { Language = "en" });
}

Response<AnalyzeSentimentResultCollection> responses = client.AnalyzeSentimentBatch(documents.GetRange(0, 10));
AnalyzeSentimentResultCollection sentimentResults = responses.Value;

Console.WriteLine("-------Results-------");

int index = 0;
foreach (var result in sentimentResults)
{
    Console.WriteLine($"Text: {comments[index++]}");
    Console.WriteLine();

    if(result.HasError) 
    {
        Console.WriteLine("  Error!");
        Console.WriteLine($"  Document error: {result.Error.ErrorCode}.");
        Console.WriteLine($"  Message: {result.Error.Message}");
    } else
    {
        Console.WriteLine($"Document sentiment is {result.DocumentSentiment.Sentiment}, with confidence scores: ");
        Console.WriteLine($"  Positive confidence score: {result.DocumentSentiment.ConfidenceScores.Positive}.");
        Console.WriteLine($"  Neutral confidence score: {result.DocumentSentiment.ConfidenceScores.Neutral}.");
        Console.WriteLine($"  Negative confidence score: {result.DocumentSentiment.ConfidenceScores.Negative}.");
        Console.WriteLine("");
    }
}