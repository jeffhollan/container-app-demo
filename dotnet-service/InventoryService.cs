public class InventoryService {
    private readonly HttpClient httpClient;
    private readonly string GO_SERVICE = Environment.GetEnvironmentVariable("GO_SERVICE") ?? "localhost:5000";

    public InventoryService(IHttpClientFactory httpClientFactory) {
        this.httpClient = httpClientFactory.CreateClient();
    }
    public async Task<string> GetInventory(string productId) {
        var res = await httpClient.GetAsync($"http://{GO_SERVICE}");
        return $"Inventory status for {productId}. {res.StatusCode}";
    }
}