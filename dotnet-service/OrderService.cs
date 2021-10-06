public class OrderService {
    private readonly HttpClient httpClient;
    private readonly string ORDER_SERVICE_NAME = Environment.GetEnvironmentVariable("ORDER_SERVICE_NAME") ?? "localhost:5000";

    public OrderService(IHttpClientFactory httpClientFactory) {
        this.httpClient = httpClientFactory.CreateClient();
    }

    public async Task<string> GetOrder(string orderId) {
        try {
            var res = await httpClient.GetAsync($"http://{ORDER_SERVICE_NAME}/order?id={orderId}");
            var resultString = await res.Content.ReadAsStringAsync();
            return $"Order status for {orderId}:\n{resultString}";
        }
        catch (Exception e)
        {
            return $"Error - order service not available";
        }
    }
}