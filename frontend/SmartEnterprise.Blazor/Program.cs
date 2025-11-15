using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.WebAssembly.Hosting;
using SmartEnterprise.Blazor;
using SmartEnterprise.Blazor.Services;

var builder = WebAssemblyHostBuilder.CreateDefault(args);
builder.RootComponents.Add<App>("#app");
builder.RootComponents.Add<HeadOutlet>("head::after");

// Configure HTTP client for backend API with better error handling
builder.Services.AddScoped(sp => new HttpClient 
{ 
    BaseAddress = new Uri("http://localhost:5001/api/"),
    Timeout = TimeSpan.FromSeconds(30)
});

// Register application services
builder.Services.AddScoped<ApiService>();
builder.Services.AddScoped<AuthService>();

// Add logging
builder.Logging.SetMinimumLevel(LogLevel.Debug);

try
{
    await builder.Build().RunAsync();
}
catch (Exception ex)
{
    // This will catch any unhandled exceptions during startup
    Console.WriteLine($"Application failed to start: {ex}");
    throw;
}