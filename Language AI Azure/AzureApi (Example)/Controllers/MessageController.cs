using Azure;
using Azure.AI.TextAnalytics;
using AzureApi.models;
using AzureApi.services;
using AzureApi.utils;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;

namespace AzureApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MessageController : ControllerBase
{
    private readonly ICosmosDbService _cosmosDbService;
    private readonly TextAnalyticsClient _textClient;
    private const string GETALL = "select * from c";
    private const string GETDATASET = "select * from messages m where m.IdDataset = ";

    public MessageController(
        ICosmosDbService cosmosDbService,
        IConfigurationSection configuration)
    {
        _cosmosDbService = cosmosDbService ?? throw new ArgumentNullException(nameof(cosmosDbService));
        _textClient = new TextAnalyticsClient(
            new Uri(configuration["URI"]),
            new AzureKeyCredential(configuration["SECRET_ENDPOINT"]));
    }

    // GET api/[controller]
    [HttpGet]
    public async Task<IResult> GetAll()
    {
        try
        {
            return Results.Ok(await _cosmosDbService.GetAllAsync(GETALL));
        }
        catch (CosmosException)
        {
            return Results.NotFound();
        }
    }

    // GET api/[controller]/{id}
    [HttpGet("{id}")]
    public async Task<IResult> GetById(string id)
    {
        try
        {
            return Results.Ok(await _cosmosDbService.GetAsync(id));
        }
        catch (CosmosException)
        {
            return Results.NotFound();
        }
    }

    // GET api/[controller]/{idDataset}/dataset
    [HttpGet("{idDataset}/dataset")]
    public async Task<IResult> GetByDataset(int idDataset)
    {
        try
        {
            return Results.Ok(await _cosmosDbService.GetAllAsync(GETDATASET + idDataset));
        }
        catch (CosmosException)
        {
            return Results.NotFound();
        }
    }

    // POST api/[controller]/single
    [HttpPost("single")]
    public async Task<IResult> PostSingle([FromBody] Message message)
    {
        Azure.Response<DocumentSentiment>
            response = await _textClient.AnalyzeSentimentAsync(message.MessageContent);
        var results = response.Value;

        message.MessageSentiment = Utils.GetSentiment(results.Sentiment);
        message.PositivePercentage = results.ConfidenceScores.Positive;
        message.NegativePercentage = results.ConfidenceScores.Negative;
        message.NeutralPercentage = results.ConfidenceScores.Neutral;

        try
        {
            await _cosmosDbService.PostAsync(message);
            return Results.Created("/", message);
        }
        catch (CosmosException)
        {
            return Results.BadRequest();
        }
    }

    // POST api/[controller]/multiple
    [HttpPost("multiple")]
    public async Task<IResult> PostMultiple([FromBody] List<Message> messages)
    {
        var splintedMessages = Utils.GetSplintedList(messages);
        var created = new List<Message>();

        try
        {
            foreach (var current in splintedMessages)
            {
                var documents = current.Select(message => message.MessageContent).ToList();

                Azure.Response<AnalyzeSentimentResultCollection> response =
                    await _textClient.AnalyzeSentimentBatchAsync(documents);
                var result = response.Value;
                var docIndex = 0;

                foreach (var document in result)
                {
                    if (document.HasError) continue;
                    var message = new Message
                    {
                        MessageContent = documents[docIndex],
                        MessageSentiment = Utils.GetSentiment(document.DocumentSentiment.Sentiment),
                        PositivePercentage = document.DocumentSentiment.ConfidenceScores.Positive,
                        NeutralPercentage = document.DocumentSentiment.ConfidenceScores.Neutral,
                        NegativePercentage = document.DocumentSentiment.ConfidenceScores.Negative,
                        IdDataset = current[docIndex++].IdDataset,
                    };
                    await _cosmosDbService.PostAsync(message);
                    created.Add(message);
                }
            }

            return Results.Created("/", created);
        }
        catch (CosmosException)
        {
            return Results.BadRequest();
        }
    }

    // PUT api/[controller]/{id}
    [HttpPut("{id}")]
    public async Task<IResult> UpdateMessage(string id, [FromBody] NewMessage newMessage)
    {
        var updatedMessage = new Message
        {
            Id = id,
            MessageContent = newMessage.NewMessageContent!,
            IdDataset = newMessage.IdDataset,
        };

        Azure.Response<DocumentSentiment> response =
            await _textClient.AnalyzeSentimentAsync(updatedMessage.MessageContent);
        var results = response.Value;

        updatedMessage.MessageSentiment = Utils.GetSentiment(results.Sentiment);
        updatedMessage.PositivePercentage = results.ConfidenceScores.Positive;
        updatedMessage.NegativePercentage = results.ConfidenceScores.Negative;
        updatedMessage.NeutralPercentage = results.ConfidenceScores.Neutral;

        try
        {
            await _cosmosDbService.UpdateAsync(updatedMessage);
            return Results.NoContent();
        }
        catch (CosmosException)
        {
            return Results.NotFound();
        }
    }

    // DELETE api/[controller]/{id}/delete
    [HttpDelete("{id}/delete")]
    public async Task<IResult> DeleteMessage(string id)
    {
        await _cosmosDbService.DeleteAsync(id);
        return Results.NoContent();
    }

    // DELETE api/[controller]/delete
    [HttpDelete("delete")]
    public async Task<IResult> DeleteAllMessages()
    {
        var data = await _cosmosDbService.GetAllAsync(GETALL);
        foreach (var currentData in data)
        {
            await _cosmosDbService.DeleteAsync(currentData.Id);
        }

        return Results.NoContent();
    }
}