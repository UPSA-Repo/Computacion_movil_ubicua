namespace AzureApi.models;

public class Message
{
    public string Id { get; set; } = Guid.NewGuid().ToString();
    public string MessageContent { get; set; } = string.Empty;
    public string? MessageSentiment { get; set; }
    public double? PositivePercentage { get; set; }
    public double? NeutralPercentage { get; set; } 
    public double? NegativePercentage { get; set; }
    public int? IdDataset { get; set; }
}