<html lang="en">

<head>
    <title>COMP214-TEAM9</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="styles.css">
</head>

<body>
    <header>
        <h2 style="font-family: Brush Script MT">Brewbean’s Coffee Shop</h2>
    </header>

    <section>
        <nav>
            <ul>
            <li><a href="homepage.php">Homepage</a></li>
                <li><a href="changeProductDesc.php">Change Product Description(Task1)</a></li>
                <li><a href="addproductdis.php">Add New Product(Task2)</a></li>
                <li><a href="taxcal.php">Calculate Tax(Task3)</a></li>
                <li><a href="updatedis.php">Update Order Status(Task4)</a></li>
                <li><a href="identifysaleproductsdis.php">Identify Sale Products(Task6)</a></li>
                <li><a href="report1.php">Check Stock Status(Report1)</a></li>
                <li><a href="totaldis.php">Check Total Cost(Report2)</a></li>
            </ul>
        </nav>

        <article>
            <h3>Add Items to Basket</h3>    
<p>

<?php

	$idBasket = $_POST['idBasket'];
	$idProduct = $_POST['idProduct'];
    $Price = $_POST['Price'];
	$Quantity = $_POST['Quantity'];
    $option1 = $_POST['option1'];
    $option2 = $_POST['option2'];
	
	$conn = oci_connect("system", "manager", "//localhost/XE");

	$sql = "BEGIN BASKET_ADD_SP(:idBasket, :idProduct, :Price, :Quantity, :option1, :option2); END;";

	$stmt = oci_parse($conn, $sql); 
	          
	oci_bind_by_name($stmt,':idBasket',$idBasket);
	oci_bind_by_name($stmt,':idProduct',$idProduct);
	oci_bind_by_name($stmt,':Price',$Price);
	oci_bind_by_name($stmt,':Quantity',$Quantity);
    oci_bind_by_name($stmt,':option1',$option1);
    oci_bind_by_name($stmt,':option2',$option2);
	
    oci_execute($stmt);

    print "The new item has been added to basket.";
    print '<br/>';
    print "Basket ID: $idBasket\n
    Product ID: $idProduct\n
    Price: $Price\n
    Quantity: $Quantity\n
    Size code: $option1\n
    Form code: $option2";
	
    oci_close($conn);
	
?>
<br>
<a href="additemtobasketdis.php">Back to submition page</a>
</p>
        </article>
    </section>

    <footer>
        <p>Copyright © 2022 COMP214-TEAM9. All rights reserved.</p>
    </footer>

</body>

</html>