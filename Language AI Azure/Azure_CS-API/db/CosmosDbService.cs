using AzureCS_API.models;
using Microsoft.Azure.Cosmos;

namespace AzureCS_API.db
{
    public class CosmosDbService : ICosmosDbService
    {
        private readonly Container _container;

        public CosmosDbService(
            CosmosClient cosmosClient, 
            string dbName, 
            string containerName)
        {
            _container = cosmosClient.GetContainer(dbName, containerName);
        }

        public async Task<IEnumerable<Message>> GetAllAsync(string queryString)
        {
            var query = _container.GetItemQueryIterator<Message>(new QueryDefinition(queryString));
            var results = new List<Message>();
            while (query.HasMoreResults)
            {
                var response = await query.ReadNextAsync();
                results.AddRange(response.ToList());
            }
            return results;
        }

        public async Task<Message> GetAsync(string id)
        {
            var response = await _container.ReadItemAsync<Message>(id, new PartitionKey(id));
            return response.Resource;
        }

        public async Task PostAsync(Message message)
        {
            await _container.CreateItemAsync(message, new PartitionKey(message.Id));
        }

        public async Task UpdateAsync(Message message)
        {
            await _container.UpsertItemAsync(message, new PartitionKey(message.Id));
        }

        public async Task<Message> DeleteAsync(string id)
        {
            return await _container.DeleteItemAsync<Message>(id, new PartitionKey(id));
        }
    }
}
