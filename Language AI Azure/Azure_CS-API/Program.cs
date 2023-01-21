using Azure;
using AzureCS_API;
using AzureCS_API.db;
using AzureCS_API.utils;
using AzureCS_API.models;
using Azure.AI.TextAnalytics;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHttpClient();

var client = new TextAnalyticsClient(new Uri(Secrets.apiEndpoint), new AzureKeyCredential(Secrets.secretEndpoint));

var section = builder.Configuration.GetSection("CosmosDb");
builder.Services.AddSingleton(Utils.InitializeCosmosClientInstanceAsync(section).GetAwaiter().GetResult());

var app = builder.Build();
app.MapGet("/", async ([FromServices] CosmosDbService db) =>
{
    try
    {
        return Results.Ok(await db.GetAllAsync("select * from c"));
    }
    catch (CosmosException)
    {
        return Results.NotFound();
    }
});

app.MapGet("/{id}", async ([FromServices] CosmosDbService db, string id) =>
{
    try
    {
        return Results.Ok(await db.GetAsync(id));
    }
    catch (CosmosException)
    {
        return Results.NotFound();
    }
});

app.MapGet("/{idDataset}/dataset", async ([FromServices] CosmosDbService db, int idDataset) =>
{
    try
    {
        return Results.Ok(await db.GetAllAsync($"SELECT * FROM messages m where m.IdDataset = {idDataset}"));
    }
    catch (CosmosException)
    {
        return Results.NotFound();
    }
});


app.MapPost("/single", async (Message message, [FromServices] CosmosDbService db) =>
{
    try
    {
        Azure.Response<DocumentSentiment> response = client.AnalyzeSentiment(message.MessageContent);
        var results = response.Value;
        message.MessageSentiment = Utils.GetSentiment(results.Sentiment);
        message.PositivePercentage = results.ConfidenceScores.Positive;
        message.NegativePercentage = results.ConfidenceScores.Negative;
        message.NeutralPercentage = results.ConfidenceScores.Neutral;
        await db.PostAsync(message);
        return Results.Created($"/{message.Id}", message);
    }
    catch (CosmosException)
    {
        return Results.BadRequest();
    }
});

app.MapPost("/multiple", async (List<Message> messages, [FromServices] CosmosDbService db) =>
{
    var created = new List<Message>();
    var splintedMessages = Utils.GetSplintedMessages(messages);

    try
    {
        foreach (var currentMessages in splintedMessages)
        {
            var documents = currentMessages.Select(message => message.MessageContent).ToList();

            Azure.Response<AnalyzeSentimentResultCollection> response = client.AnalyzeSentimentBatch(documents);
            var results = response.Value;
        
            var docIndex = 0;
            foreach(var document in results)
            {
                if (document.HasError) continue;
                var message = new Message
                {
                    MessageContent = documents[docIndex],
                    MessageSentiment = Utils.GetSentiment(document.DocumentSentiment.Sentiment),
                    PositivePercentage = document.DocumentSentiment.ConfidenceScores.Positive,
                    NeutralPercentage = document.DocumentSentiment.ConfidenceScores.Neutral,
                    NegativePercentage = document.DocumentSentiment.ConfidenceScores.Negative,
                    IdDataset = currentMessages[docIndex++].IdDataset,
                };
                await db.PostAsync(message);
                created.Add(message);
            }
        }
    
        return Results.Created($"/", created);
    }
    catch (CosmosException)
    {
        return Results.BadRequest();
    }
});

// PUT
app.MapPut("/{id}", async (string id, [FromServices] CosmosDbService db, [FromBody]NewMessageDto messageDto)
    =>
{
    var updateMessage = new Message { 
        Id = id,
        MessageContent = messageDto.NewMessage,
        IdDataset = messageDto.IdDataset,
    };
    
    DocumentSentiment document = client.AnalyzeSentiment(updateMessage.MessageContent);
    updateMessage.MessageSentiment = Utils.GetSentiment(document.Sentiment);
    updateMessage.PositivePercentage = document.ConfidenceScores.Positive;
    updateMessage.NegativePercentage = document.ConfidenceScores.Negative;
    updateMessage.NeutralPercentage = document.ConfidenceScores.Neutral;
    
    await db.UpdateAsync(updateMessage);
    return Results.NoContent();
});

// DELETE
app.MapDelete("/{id}", async ([FromServices] CosmosDbService db, string id) =>
{
    try
    {
        await db.DeleteAsync(id);
        return Results.NoContent();
    }
    catch (CosmosException)
    {
        return Results.NotFound();
    }
});

app.MapDelete("/delete/all", async ([FromServices] CosmosDbService db) => 
{
    try
    {
        var data = await db.GetAllAsync("select * from c");
        foreach(var item in data)
        {
            await db.DeleteAsync(item.Id);
        }
        return Results.NoContent();
    }
    catch (CosmosException)
    {
        return Results.NotFound();
    }
});

app.MapDelete("/{idDataset}/delete", async(int idDataset, [FromServices] CosmosDbService db) => {
    try
    {
        var list = await db.GetAllAsync(
            $"SELECT * FROM messages m where m.IdDataset = {idDataset}");
        foreach(var item in list)
        {
            await db.DeleteAsync(item.Id);
        }
        return Results.NoContent();
    }
    catch (CosmosException)
    {
        return Results.NotFound();
    }
});

app.Run();