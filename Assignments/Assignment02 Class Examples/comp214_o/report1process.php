<html lang="en">

<head>
    <title>COMP214-TEAM9</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="styles.css">
</head>

<body>
    <header>


        <h2 style="font-family: Brush Script MT">
            Brewbean’s
            Coffee Shop</h2>

    </header>

    <section>
        <nav>
            <ul>
            <li><a href="homepage.php">Homepage</a></li>
                <li><a href="changeProductDesc.php">Change Product Description(Task1)</a></li>
                <li><a href="addproductdis.php">Add New Product(Task2)</a></li>
                <li><a href="taxcal.php">Calculate Tax(Task3)</a></li>
                <li><a href="updatedis.php">Update Order Status(Task4)</a></li>
                <li><a href="additemtobasketdis.php">Add Items to Basket(Task5)</a></li>
                <li><a href="identifysaleproductsdis.php">Identify Sale Products(Task6)</a></li>
                <li><a href="totaldis.php">Check Total Cost(Report2)</a></li> 
            </ul>
        </nav>

        <article>

    <h3>Check Stock Status</h3>
        <p>
        <?php
// Assign a value from the input 
$p_id_basket = $_POST['p_id_basket'];


$conn = oci_connect("system", "manager", "//localhost/XE");
$sql = 'BEGIN DISPLAY_STOCK(:p_id_basket, :output); END;';
 
 $stmt = oci_parse($conn,$sql);
 
 // Bind the input parameter
 oci_bind_by_name($stmt,':p_id_basket',$p_id_basket,32);
 
 // Bind the output parameter

 oci_bind_by_name($stmt,':output',$output,32);
 
 oci_execute($stmt);
 

 print "$output\n";

  // Close the Oracle connection
oci_close($conn);
 ?>
<br>
<a href="report1.php">Back to submition page</a>
</p>
        </article>
    </section>

    <footer>
        <p>Copyright © 2022 COMP214-TEAM9. All rights reserved.</p>
    </footer>

</body>

</html>