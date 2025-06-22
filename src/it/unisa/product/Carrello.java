package it.unisa.product;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Carrello {
	private ArrayList<ItemOrder> itemsOrdered;	
	public Carrello () {
		itemsOrdered = new ArrayList<ItemOrder>();
	}
	
	public synchronized void addCarrello(int itemID) {
		ProductModel model = new ProductModelDS();

		
		ItemOrder order;
		
		for(int i=0; i<itemsOrdered.size(); i++) {
			order = (ItemOrder)itemsOrdered.get(i);
			if(order.getItemID() == itemID) {
				order.incrementNumItems();
				return;
			}
		}	
		
		try{
	    ItemOrder newOrder = new ItemOrder(model.doRetrieveByKey(itemID));
	    itemsOrdered.add(newOrder);
		} catch(SQLException e) {
			e.getMessage();
		}
	}
	
	public void deleteCarrello(ProductBean bean) {
		for(ItemOrder beanC : itemsOrdered) {
			if(beanC.getItemID() == bean.getIdProdotto())
				itemsOrdered.remove(beanC);
			break;
		}
	}
	
	public List<ItemOrder> getProdotti(){
		return itemsOrdered;
	}
}
