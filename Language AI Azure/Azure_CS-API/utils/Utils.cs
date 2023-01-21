using Azure.AI.TextAnalytics;
using AzureCS_API.db;
using AzureCS_API.models;

namespace AzureCS_API.utils
{
    public static class Utils
    {
        public static string GetSentiment(TextSentiment sentiment)
        {
            switch(sentiment)
            {
                case TextSentiment.Positive:
                    return "Positivo";
                case TextSentiment.Neutral:
                    return "Neutral";
                case TextSentiment.Negative:
                    return "Negativo";
                case TextSentiment.Mixed:
                    return "Mixto";
                default:
                    return "Error";
            }
        }

        public static List<List<Message>> GetSplintedMessages(List<Message> messages)
        {
            return messages.Select((x, i) => new { Index = i, Value = x})
                .GroupBy(x => x.Index / 10)
                .Select(x => x.Select(v => v.Value).ToList())
                .ToList();
        }
        
        public static async Task<CosmosDbService> InitializeCosmosClientInstanceAsync(IConfigurationSection configurationSection)
        {
            var account = configurationSection["Account"];
            var key = configurationSection["Key"];
            var databaseName = configurationSection["DatabaseName"];
            var containerName = configurationSection["ContainerName"];

            var client = new Microsoft.Azure.Cosmos.CosmosClient(account, key);
            var database = await client.CreateDatabaseIfNotExistsAsync(databaseName);
            await database.Database.CreateContainerIfNotExistsAsync(containerName, "/id");
            var cosmosDbService = new CosmosDbService(client, databaseName, containerName);
            return cosmosDbService;
        }
    }
}
