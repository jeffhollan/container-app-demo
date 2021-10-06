// My store service

using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHttpClient();
builder.Services.AddSingleton<OrderService, OrderService>();
builder.Services.AddSingleton<InventoryService, InventoryService>();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Store API", Description = "Store operations", Version = "v1" });
});

var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.MapGet("/order", 
    (HttpContext context, OrderService service) => 
    service.GetOrder(context.Request.Query["id"].ToString()));

app.MapGet("/inventory",
    (HttpContext context, InventoryService service) => 
    service.GetInventory(context.Request.Query["id"].ToString()));

// http://endpoint/swagger/v1/swagger.json
app.UseSwagger();
app.Run();
