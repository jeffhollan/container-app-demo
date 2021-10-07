public class OrderService {
    private readonly HttpClient httpClient;
    private readonly string orderService = $"http://localhost:{Environment.GetEnvironmentVariable("DAPR_HTTP_PORT")}/v1.0/invoke/{Environment.GetEnvironmentVariable("ORDER_SERVICE_NAME")}/method";

    public OrderService(IHttpClientFactory httpClientFactory) {
        this.httpClient = httpClientFactory.CreateClient();
    }

    public async Task<string> GetOrder(string orderId) {
        try {
            var res = await httpClient.GetAsync($"{orderService}/order?id={orderId}");
            var resultString = await res.Content.ReadAsStringAsync();
            return $"Order status for {orderId}:\n{resultString}";
        }
        catch (Exception e)
        {
            return $"Error - order service not available";
        }
    }
}