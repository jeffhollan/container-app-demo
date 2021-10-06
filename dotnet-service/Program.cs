using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHttpClient();
builder.Services.AddSingleton<OrderService, OrderService>();
builder.Services.AddSingleton<InventoryService, InventoryService>();

var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.MapGet("/order", 
    (HttpContext context, OrderService service) => 
    service.GetOrder(context.Request.Query["id"].ToString()));

app.MapGet("/inventory",
    (HttpContext context, InventoryService service) => 
    service.GetInventory(context.Request.Query["id"].ToString()));

app.Run();
