<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
?>

<!DOCTYPE html>
<html>
<body>
<h2>User Signup</h2>
<form method="POST" action="form.php">
  Name: <input type="text" name="name"><br><br>
  Email: <input type="email" name="email"><br><br>
  <input type="submit" value="Submit">
</form>
</body>
</html>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    echo "<br>Form submitted.<br>";

    // Replace these with your actual credentials
    $conn = new mysqli("your-rds-endpoint", "your-db-user", "your-db-password", "myapp");

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    } else {
        echo "Connected to database.<br>";
    }

    $name = $_POST['name'];
    $email = $_POST['email'];

    echo "Received name: $name, email: $email<br>";

    $stmt = $conn->prepare("INSERT INTO users (name, email) VALUES (?, ?)");
    if (!$stmt) {
        die("Prepare failed: " . $conn->error);
    }

    $stmt->bind_param("ss", $name, $email);

    if (!$stmt->execute()) {
        die("Execute failed: " . $stmt->error);
    } else {
        echo "User data saved successfully!";
    }

    $stmt->close();
    $conn->close();
}
?>

