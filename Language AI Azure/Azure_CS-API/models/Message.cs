using Newtonsoft.Json;

namespace AzureCS_API.models
{
    public class Message
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; set; } = Guid.NewGuid().ToString();
        [JsonProperty(PropertyName = "message")]
        public string MessageContent { get; set; } = string.Empty;
        public string? MessageSentiment { get; set; }
        public double? PositivePercentage { get; set; }
        public double? NeutralPercentage { get; set; } 
        public double? NegativePercentage { get; set; }
        public int? IdDataset { get; set; }
    }
}
