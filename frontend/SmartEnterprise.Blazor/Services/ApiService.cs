using System.Net.Http.Json;

namespace SmartEnterprise.Blazor.Services;

public class ApiService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<ApiService> _logger;
    
    public ApiService(HttpClient httpClient, ILogger<ApiService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
    }
    
    public async Task<T?> GetAsync<T>(string endpoint)
    {
        try
        {
            _logger.LogInformation($"Making API call to: {endpoint}");
            var response = await _httpClient.GetAsync(endpoint);
            
            if (response.IsSuccessStatusCode)
            {
                return await response.Content.ReadFromJsonAsync<T>();
            }
            else
            {
                _logger.LogWarning($"API call failed with status: {response.StatusCode}");
                return default;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"API Error calling {endpoint}: {ex.Message}");
            return default;
        }
    }
    
    public async Task<bool> HealthCheckAsync()
    {
        try
        {
            _logger.LogInformation("Checking backend health...");
            var response = await _httpClient.GetAsync("health");
            
            if (response.IsSuccessStatusCode)
            {
                _logger.LogInformation("Backend health check: SUCCESS");
                return true;
            }
            else
            {
                _logger.LogWarning($"Backend health check failed: {response.StatusCode}");
                return false;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, $"Health check failed: {ex.Message}");
            return false;
        }
    }
}

public class AuthService
{
    public bool IsAuthenticated { get; private set; }
    
    public void Login()
    {
        IsAuthenticated = true;
    }
    
    public void Logout()
    {
        IsAuthenticated = false;
    }
}