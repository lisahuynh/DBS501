
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
                <li><a href="taxcal.php">Calculate Tax(Task3)</a></li>
                <li><a href="updatedis.php">Update Order Status(Task4)</a></li>
                <li><a href="additemtobasketdis.php">Add Items to Basket(Task5)</a></li>
                <li><a href="identifysaleproductsdis.php">Identify Sale Products(Task6)</a></li>
                <li><a href="report1.php">Check Stock Status(Report1)</a></li>
                <li><a href="totaldis.php">Check Total Cost(Report2)</a></li>  
            </ul>
        </nav>

        <article>
            <h3>Add New Product</h3>
            <form action="addproductprocess.php" method="POST">
		<p>	
			<label>Product_ID:</label>
            <input type="number" min="1" max="100" step="1" value="1" name="idProduct">
		</p>
        <p>
			<label>Product Name:</label>
			<input type="text" name="ProductName"/>
		</p>
		<p>
			<label>Description:</label>
			<input type="text" name="Description"/>
		</p>
        <p>
			<label>Product Image:</label>
			<input type="text" name="ProductImage"/>
		</p>
        <p>
			<label>Price:</label>
			<input type="text" name="Price"/>
		</p>
        <p>
			<label>Active:</label>
			<input type="text" name="Active"/>
		</p>
		<p>
			<input type="submit" value="Submit" />
		</p>
	</form>

    <h3>Search Product</h3>
    <form action="searchproductprocess.php" method="POST">
		<p>	
			<label>Product Name:</label>
            <input type="text" name="ProductName">
		</p>
        <p>
			<input type="submit" value="Submit" />
		</p>

        </form>




        

</p>
        </article>
    </section>

    <footer>
        <p>Copyright © 2022 COMP214-TEAM9. All rights reserved.</p>
    </footer>

</body>

</html>