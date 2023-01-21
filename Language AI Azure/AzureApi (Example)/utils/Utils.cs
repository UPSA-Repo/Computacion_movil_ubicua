using Azure.AI.TextAnalytics;
using AzureApi.models;

namespace AzureApi.utils;

public class Utils
{
    public static string GetSentiment(TextSentiment sentiment)
    {
        return sentiment switch
        {
            TextSentiment.Positive => "Positivo",
            TextSentiment.Neutral => "Neutral",
            TextSentiment.Negative => "Negativo",
            TextSentiment.Mixed => "Mixto",
            _ => "Error"
        };
    }

    public static List<List<Message>> GetSplintedList(List<Message> messages)
    {
        return messages.Select((x, i) => new {Index = i, Value = x})
            .GroupBy(x => x.Index/10)
            .Select(x => x.Select(v => v.Value).ToList())
            .ToList();
    }
}