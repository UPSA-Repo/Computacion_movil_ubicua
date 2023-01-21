using AzureApi.services;
using Microsoft.Azure.Cosmos;

var builder = WebApplication.CreateBuilder(args);

static Task<CosmosDbService> InitializeCosmosClientInstanceAsync(IConfigurationSection configurationSection)
{
    var account = configurationSection["Account"];
    var key = configurationSection["Key"];
    var databaseName = configurationSection["DatabaseName"];
    var containerName = configurationSection["ContainerName"];

    var client = new CosmosClient(account, key);
    return Task.FromResult(new CosmosDbService(client, databaseName, containerName)); 
}

var conf = builder.Configuration.GetSection("CosmosDb");
builder.Services.AddHttpClient();
builder.Services.AddSingleton(InitializeCosmosClientInstanceAsync(conf).GetAwaiter().GetResult());

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.Run();
