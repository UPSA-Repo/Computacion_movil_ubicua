using AzureCS_API.models;

namespace AzureCS_API.db
{
    public interface ICosmosDbService
    {
        Task<IEnumerable<Message>> GetAllAsync(string queryString);
        Task<Message> GetAsync(string id);
        Task PostAsync(Message message);
        Task UpdateAsync(Message message);
        Task<Message> DeleteAsync(string id);
    }
}
