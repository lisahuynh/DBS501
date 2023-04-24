
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
                <li><a href="report1.php">Check Stock Status(Report1)</a></li>
            </ul>
        </nav>

        <article>

    <h3>Check Total Cost</h3>
       
<p>
<?php
// Assign a value from the input 
$shopper_id = $_POST['shopper_id'];



$conn = oci_connect("system", "manager", "//localhost/XE");
$sql = 'BEGIN :V_TOTAL := tot_purch_sf(:shopper_id); END;';
 
 $stmt = oci_parse($conn,$sql);
 
 // Bind the input parameter
 oci_bind_by_name($stmt,':shopper_id',$shopper_id,10);
 
 // Bind the output parameter
 oci_bind_by_name($stmt,':V_TOTAL',$V_TOTAL,10);

 
 oci_execute($stmt);
 
 print "The total cost will be $$V_TOTAL\n";

  // Close the Oracle connection
oci_close($conn);
 ?>
<br>
<a href="totaldis.php">Back to submition page</a>
</p>
        </article>
    </section>

    <footer>
        <p>Copyright © 2022 COMP214-TEAM9. All rights reserved.</p>
    </footer>

</body>

</html>