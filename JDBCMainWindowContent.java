import java.awt.*;
import java.awt.event.*;
import java.io.FileWriter;
import java.io.PrintWriter;
import javax.swing.*;
import javax.swing.border.*;
import java.sql.*;

@SuppressWarnings("serial")
public class JDBCMainWindowContent extends JInternalFrame implements ActionListener
{	
	String cmd = null;

	// DB Connectivity Attributes
	private Connection con = null;
	private Statement stmt = null;
	private ResultSet rs = null;

	private Container content;

	private JPanel detailsPanel;
	private JPanel exportButtonPanel;
	//private JPanel exportConceptDataPanel;
	private JScrollPane dbContentsPanel;

	private Border lineBorder;

	private JLabel ParcelIDLabel=new JLabel("Parcel ID:      (Delete,Update)");
	private JLabel CustomersIDLabel=new JLabel("Customers ID:      (Insert/Update)");
	private JLabel WeightLabel=new JLabel("Weight:               (Insert/Update)");
	private JLabel DimensionsLabel=new JLabel("Dimensions:        (Insert/Update)");
	private JLabel StatusLabel=new JLabel("Status:                 (Insert/Update)");

	private JTextField ParcelIDTF= new JTextField(10);
	private JTextField CustomersIDTF= new JTextField(10);
	private JTextField WeightTF=new JTextField(10);
	private JTextField DimensionsTF=new JTextField(10);
	private JTextField StatusTF=new JTextField(10);

	private static QueryTableModel TableModel = new QueryTableModel();
	//Add the models to JTabels
	private JTable TableofDBContents=new JTable(TableModel);
	//Buttons for inserting, and updating members
	//also a clear button to clear details panel
	private JButton updateButton = new JButton("Update");
	private JButton insertButton = new JButton("Insert");
	private JButton exportButton  = new JButton("Export");
	private JButton deleteButton  = new JButton("Delete");
	private JButton clearButton  = new JButton("Clear");
	private JButton auditButton  = new JButton("Audit");

	private JButton  NumShipments = new JButton("Total Shipments cost(CustomerID):");
	private JTextField NumShipmentsTF  = new JTextField(12);
	private JButton avgWeightParcel  = new JButton("AVG Parcels Weight(Vechile type)");
	private JTextField avgWeightParcelTF  = new JTextField(12);
	private JButton ListVehicles  = new JButton("ListAllVehicles");
	private JButton StatusOfDeliveries  = new JButton("StatusOfDeliveries");



	public JDBCMainWindowContent( String aTitle)
	{	
		//setting up the GUI
		super(aTitle, false,false,false,false);
		setEnabled(true);

		initiate_db_conn();
		//add the 'main' panel to the Internal Frame
		content=getContentPane();
		content.setLayout(null);
		content.setBackground(Color.lightGray);
		lineBorder = BorderFactory.createEtchedBorder(15, Color.red, Color.black);

		//setup details panel and add the components to it
		detailsPanel=new JPanel();
		detailsPanel.setLayout(new GridLayout(11,2));
		detailsPanel.setBackground(Color.lightGray);
		detailsPanel.setBorder(BorderFactory.createTitledBorder(lineBorder, "CRUD Actions"));

		detailsPanel.add(ParcelIDLabel);			
		detailsPanel.add(ParcelIDTF);
		detailsPanel.add(CustomersIDLabel);			
		detailsPanel.add(CustomersIDTF);
		detailsPanel.add(WeightLabel);		
		detailsPanel.add(WeightTF);
		detailsPanel.add(DimensionsLabel);		
		detailsPanel.add(DimensionsTF);
		detailsPanel.add(StatusLabel);	
		detailsPanel.add(StatusTF);

		//setup details panel and add the components to it
		exportButtonPanel=new JPanel();
		exportButtonPanel.setLayout(new GridLayout(3,2));
		exportButtonPanel.setBackground(Color.lightGray);
		exportButtonPanel.setBorder(BorderFactory.createTitledBorder(lineBorder, "Export Data"));
		exportButtonPanel.add(NumShipments);
		exportButtonPanel.add(NumShipmentsTF);
		exportButtonPanel.add(avgWeightParcel);
		exportButtonPanel.add(avgWeightParcelTF);
		exportButtonPanel.add(ListVehicles);
		exportButtonPanel.add(StatusOfDeliveries);
		exportButtonPanel.setSize(500, 200);
		exportButtonPanel.setLocation(3, 300);
		content.add(exportButtonPanel);

		insertButton.setSize(100, 30);
		updateButton.setSize(100, 30);
		exportButton.setSize (100, 30);
		deleteButton.setSize (100, 30);
		clearButton.setSize (100, 30);
		auditButton.setSize (100, 30);

		insertButton.setLocation(370, 10);
		updateButton.setLocation(370, 110);
		exportButton.setLocation (370, 160);
		deleteButton.setLocation (370, 60);
		clearButton.setLocation (370, 210);
		auditButton.setLocation (370, 260);
		

		insertButton.addActionListener(this);
		updateButton.addActionListener(this);
		exportButton.addActionListener(this);
		deleteButton.addActionListener(this);
		clearButton.addActionListener(this);
		auditButton.addActionListener(this);

		this.ListVehicles.addActionListener(this);
		this.avgWeightParcel.addActionListener(this);
		this.NumShipments.addActionListener(this);
		this.StatusOfDeliveries.addActionListener(this);

		content.add(insertButton);
		content.add(updateButton);
		content.add(exportButton);
		content.add(deleteButton);
		content.add(clearButton);
		content.add(auditButton);


		TableofDBContents.setPreferredScrollableViewportSize(new Dimension(900, 300));

		dbContentsPanel=new JScrollPane(TableofDBContents,JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
		dbContentsPanel.setBackground(Color.lightGray);
		dbContentsPanel.setBorder(BorderFactory.createTitledBorder(lineBorder,"Database Content"));

		detailsPanel.setSize(360, 300);
		detailsPanel.setLocation(3,0);
		dbContentsPanel.setSize(700, 300);
		dbContentsPanel.setLocation(477, 0);

		content.add(detailsPanel);
		content.add(dbContentsPanel);

		setSize(982,645);
		setVisible(true);

		TableModel.refreshFromDB(stmt);
	}

	public void initiate_db_conn()
	{
		try
		{
			// Load the JConnector Driver
			Class.forName("com.mysql.cj.jdbc.Driver");
			// Specify the DB Name
            String url="jdbc:mysql://localhost:3307/ParcelDeliveryDB";
			
			// Connect to DB using DB URL, Username and password
			con = DriverManager.getConnection(url, "root", "");
			
			//Create a generic statement which is passed to the TestInternalFrame1
			stmt = con.createStatement();
		}
		catch(Exception e)
		{
			System.out.println("Error: Failed to connect to database\n"+e.getMessage());
		}
	}

	//event handling 
	public void actionPerformed(ActionEvent e)
	{
		Object target=e.getSource();
		if (target == clearButton)
		{
			ParcelIDTF.setText("");
			CustomersIDTF.setText("");
			WeightTF.setText("");
			DimensionsTF.setText("");
			StatusTF.setText("");
		}
		
		//INSERT ( Only Customers)
		if (target == insertButton)
		{		 
			try
			{
				String updateTemp = "INSERT INTO parcels_view (CustomerID, Weight, Dimensions, Status) VALUES ('" 
	                    + CustomersIDTF.getText() + "', '" 
	                    + WeightTF.getText() + "', '" 
	                    + DimensionsTF.getText() + "', '" 
	                    + StatusTF.getText() + "')";

				stmt.executeUpdate(updateTemp);

			}
			catch (SQLException sqle)
			{
				System.err.println("Error with  insert:\n"+sqle.toString());
			}
			finally
			{
				TableModel.refreshFromDB(stmt);
			}
		}
		//DELETE (Only Customers based on CustID)
				if (target == deleteButton){		 
					String turnOffFKC = "SET FOREIGN_KEY_CHECKS=0;";
					String turnOnFKC = "SET FOREIGN_KEY_CHECKS=1;";
					String ParcelID = this.ParcelIDTF.getText();
					try
					{
						String deleteTemp = "DELETE FROM parcels_view WHERE ParcelID = " + ParcelID+ ";";
						System.out.println(deleteTemp);
						stmt.executeUpdate(turnOffFKC);
						stmt.executeUpdate(deleteTemp);
						stmt.executeUpdate(turnOnFKC);

					}
					catch (SQLException sqle)
					{
						System.err.println("Error with  insert:\n"+sqle.toString());
					}
					finally
					{
						TableModel.refreshFromDB(stmt);
					}
				}
		//UPDATE (Only for address based on CustID)
				if (target == updateButton){		 
//					String turnOffFKC = "SET FOREIGN_KEY_CHECKS=0;";
//					String turnOnFKC = "SET FOREIGN_KEY_CHECKS=1;";
					String ParcelID = this.ParcelIDTF.getText();
					String CustomersID = this.CustomersIDTF.getText();
					String Weight = this.WeightTF.getText();
					String Dimensions = this.DimensionsTF.getText();
					String Status = this.StatusTF.getText();
					try
					{
						 String updateTemp = "UPDATE parcels_view SET CustomerID = '" + CustomersID 
			                        + "', Weight = '" + Weight 
			                        + "', Dimensions = '" + Dimensions 
			                        + "', Status = '" + Status 
			                        + "' WHERE ParcelID = " + ParcelID + ";";
						System.out.println(updateTemp);
//						stmt.executeUpdate(turnOffFKC);
						stmt.executeUpdate(updateTemp);
//						stmt.executeUpdate(turnOnFKC);

					}
					catch (SQLException sqle)
					{
						System.err.println("Error with  insert:\n"+sqle.toString());
					}
					finally
					{
						TableModel.refreshFromDB(stmt);
					}
				}
			//EXPORT
				if(target == this.exportButton){

					cmd = "select * FROM Parcels;";

					try{					
						rs= stmt.executeQuery(cmd); 	
						writeToFile(rs);
					}
					catch(Exception e1){e1.printStackTrace();}

				}
				
			// Audit
				if(target == this.auditButton){

					cmd = "SELECT * FROM Parcels_audit;";

					try{					
						rs= stmt.executeQuery(cmd); 	
						writeToFile(rs);
					}
					catch(Exception e1){e1.printStackTrace();}

				}
		//List of Distinct Vehicles
		if(target == this.ListVehicles){

			cmd = "select distinct Vehicle from Deliveries;";

			try{					
				rs= stmt.executeQuery(cmd); 	
				writeToFile(rs);
			}
			catch(Exception e1){e1.printStackTrace();}

		}
		
		//Average Weight of Parcel
				if(target == this.avgWeightParcel){
					String Vechile = this.avgWeightParcelTF.getText();
					cmd = "SELECT \r\n"
							+ "    d.Vehicle,\r\n"
							+ "    ROUND(AVG(p.Weight), 2) as AverageWeight\r\n"
							+ "FROM \r\n"
							+ "    Deliveries d\r\n"
							+ "    JOIN Parcels p ON d.ParcelID = p.ParcelID\r\n"
							+ "WHERE Vehicle = '" + Vechile+"';";

					try{					
						rs= stmt.executeQuery(cmd); 	
						writeToFile(rs);
					}
					catch(Exception e1){e1.printStackTrace();}

				}

		//Shipment cost
		if(target == this.NumShipments){
			String CustID = this.NumShipmentsTF.getText();

			cmd = "SELECT fnCalculateShippingCostTotal(  '" +CustID+ "') AS ShippingCostTotal;";

			System.out.println(cmd);
			try{					
				rs= stmt.executeQuery(cmd); 	
				writeToFile(rs);
				
			}
			catch(Exception e1){e1.printStackTrace();}

		} 
		
		//Status of Deliveries
				if(target == this.StatusOfDeliveries){
					cmd = "SELECT Status, COUNT(*) AS ParcelCount\r\n"
							+ "FROM Parcels\r\n"
							+ "GROUP BY Status;";
					System.out.println(cmd);
					try{					
						rs= stmt.executeQuery(cmd); 	
						writeToFile(rs);
						
					}
					catch(Exception e1){e1.printStackTrace();}


				}
		//Stored Function
				
	}
	
	///////////////////////////////////////////////////////////////////////////

	private void writeToFile(ResultSet rs){
		try{
			System.out.println("In writeToFile");
			FileWriter outputFile = new FileWriter("MyOutput.csv");
			PrintWriter printWriter = new PrintWriter(outputFile);
			ResultSetMetaData rsmd = rs.getMetaData();
			int numColumns = rsmd.getColumnCount();
			
			for(int i=0;i<numColumns;i++){
				printWriter.print(rsmd.getColumnLabel(i+1)+",");
			}
			printWriter.print("\n");
			while(rs.next()){
				for(int i=0;i<numColumns;i++){
					printWriter.print(rs.getString(i+1)+",");
					//Message displaying DeliveryCount without opening MyOutput.csv
					System.out.println(rsmd.getColumnLabel(i + 1)+ " = " +rs.getString(i + 1));
				}
				printWriter.print("\n");
				printWriter.flush();
			}
			printWriter.close();
		}
		catch(Exception e){e.printStackTrace();}
	}
}
