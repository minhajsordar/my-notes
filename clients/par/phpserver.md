To create a basic API with `GET`, `POST`, `PUT`, and `DELETE` routes in native PHP, you need to set up a structure that allows you to route incoming HTTP requests and handle each HTTP method. Here's how you can do it, along with a suggested folder structure.

### 1. **File/Folder Structure**

You can organize your project like this:

```
project-root/
│
├── api/
│   └── product.php
├── includes/
│   └── dbconfig.php
├── public/
│   └── index.php
└── .htaccess
```

### 2. **Basic Routing Logic in `index.php`**

In your `public/index.php` file, you can set up a simple routing system. This will route all requests to the appropriate file based on the URL path and HTTP method.

```php
<?php
// Enable CORS headers for the API (optional)
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Get the request method
$method = $_SERVER['REQUEST_METHOD'];

// Get the requested URI
$requestUri = $_SERVER['REQUEST_URI'];

// Simple routing logic
if (preg_match("/\/api\/product/", $requestUri)) {
    include '../api/product.php';
} else {
    // 404 Not Found
    http_response_code(404);
    echo json_encode(['message' => 'Endpoint not found']);
}
?>
```

### 3. **Handle Requests in `api/product.php`**

This file will handle the `GET`, `POST`, `PUT`, and `DELETE` requests for the `/api/product` route. You can separate each method based on `$_SERVER['REQUEST_METHOD']`.

```php
<?php

include '../includes/dbconfig.php';

// Fetch the request method
$method = $_SERVER['REQUEST_METHOD'];

// Extract product ID from the URL if provided (e.g., /api/product/123)
$requestUri = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
$productId = isset($requestUri[3]) ? $requestUri[3] : null;

// Handle different request methods
switch ($method) {
    case 'GET':
        // Get a list of products or a single product if ID is provided
        if ($productId) {
            getProduct($productId);
        } else {
            getAllProducts();
        }
        break;
    case 'POST':
        // Create a new product
        createProduct();
        break;
    case 'PUT':
        // Update an existing product
        if ($productId) {
            updateProduct($productId);
        } else {
            echo json_encode(['message' => 'Product ID is required']);
        }
        break;
    case 'DELETE':
        // Delete a product
        if ($productId) {
            deleteProduct($productId);
        } else {
            echo json_encode(['message' => 'Product ID is required']);
        }
        break;
    default:
        http_response_code(405);
        echo json_encode(['message' => 'Method Not Allowed']);
}

// Functions to handle requests
function getAllProducts() {
    // Implement logic to retrieve all products from the database
    echo json_encode(['message' => 'Fetching all products']);
}

function getProduct($id) {
    // Implement logic to retrieve a specific product by its ID
    echo json_encode(['message' => 'Fetching product with ID ' . $id]);
}

function createProduct() {
    // Read input data
    $data = json_decode(file_get_contents('php://input'), true);

    // Implement logic to create a new product in the database
    echo json_encode(['message' => 'Product created', 'data' => $data]);
}

function updateProduct($id) {
    // Read input data
    $data = json_decode(file_get_contents('php://input'), true);

    // Implement logic to update a specific product by its ID
    echo json_encode(['message' => 'Product updated with ID ' . $id, 'data' => $data]);
}

function deleteProduct($id) {
    // Implement logic to delete a specific product by its ID
    echo json_encode(['message' => 'Product deleted with ID ' . $id]);
}

?>
```

### 4. **Database Configuration in `includes/dbconfig.php`**

This file will contain the database connection setup. You can replace the connection parameters with your actual database details.

```php
<?php
// Database connection configuration
$host = 'localhost';
$dbname = 'your_database';
$username = 'your_username';
$password = 'your_password';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['message' => 'Database connection failed: ' . $e->getMessage()]);
    exit();
}
?>
```

### 5. **Rewrite Rules in `.htaccess`**

If you're using Apache, you'll need an `.htaccess` file in the `public/` directory to route all requests to `index.php`.

```bash
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php [QSA,L]
```

This will ensure that all incoming requests are directed to `index.php`, which then routes the request based on the URL.

---

### Example API Request

- **GET** `/api/product` → Fetch all products
- **GET** `/api/product/123` → Fetch product with ID 123
- **POST** `/api/product` → Create a new product (expects JSON data in the body)
- **PUT** `/api/product/123` → Update product with ID 123 (expects JSON data in the body)
- **DELETE** `/api/product/123` → Delete product with ID 123

---

### Conclusion

This structure gives you a simple way to implement basic RESTful routes in native PHP. It allows you to handle different HTTP methods and route requests based on URL patterns. You can extend this structure by adding more routes and modularizing your code further by breaking down product-specific logic into separate classes or files.