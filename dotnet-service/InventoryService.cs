public class InventoryService {
    private readonly HttpClient httpClient;
    private readonly string inventoryService = $"http://localhost:{Environment.GetEnvironmentVariable("DAPR_HTTP_PORT")}/v1.0/invoke/{Environment.GetEnvironmentVariable("INVENTORY_SERVICE_NAME")}";

    public InventoryService(IHttpClientFactory httpClientFactory) {
        this.httpClient = httpClientFactory.CreateClient();
    }
    public async Task<string> GetInventory(string productId) {
        try {
            var res = await httpClient.GetAsync($"{inventoryService}/method/inventory");
            var resultString = await res.Content.ReadAsStringAsync();
            return $"Inventory status for {productId}: {resultString}";
        }
        catch (Exception e)
        {
            return $"Error - inventory service not available";
        }
    }
}