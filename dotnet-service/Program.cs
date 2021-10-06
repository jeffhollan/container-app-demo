using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHttpClient();
builder.Services.AddSingleton<OrderService, OrderService>();

var app = builder.Build();

app.MapGet("/", () => "Hello World!");

app.MapGet("/order", 
    (HttpContext context, OrderService service) => 
    service.GetOrder(context.Request.Query["id"].ToString()));

app.Run();
