public class OrderService {
    private readonly HttpClient httpClient;
    private readonly string PYTHON_SERVICE = Environment.GetEnvironmentVariable("PYTHON_SERVICE") ?? "localhost:5000";

    public OrderService(IHttpClientFactory httpClientFactory) {
        this.httpClient = httpClientFactory.CreateClient();
    }

    public async Task<string> GetOrder(string orderId) {
        try {
            var res = await httpClient.GetAsync($"http://{PYTHON_SERVICE}/order?id={orderId}");
            var resultString = await res.Content.ReadAsStringAsync();
            return $"Order status for {orderId}:\n{resultString}";
        }
        catch (Exception e)
        {
            return $"Error - order service not available";
        }
    }
}