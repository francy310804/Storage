package it.unisa.product;


/* Questa classe rappresenta la voce del nostro carrello
che è formata dal productBean + la relativa quantità*/

public class ItemOrder {
	private ProductBean item;
	private int numItems;
	
	
	public ItemOrder(ProductBean item) {
	    setItem(item);
	    setNumItems(1);
	}
	
	public int getItemID() {
		return(getItem().getIdProdotto());
	}
	
	public ProductBean getItem() {
		return(item);
	}
	
	protected void setItem(ProductBean item) {
		this.item = item;
	}
	
	public String getNome() {
		return(getItem().getNome());
	}

	public double getUnitCost() {
		return(getItem().getPrezzo());
	}
		  
	public int getNumItems() {
		return(numItems);
	}

	public void setNumItems(int n) {
		this.numItems = n;
	}

	public void incrementNumItems() {
		setNumItems(getNumItems() + 1);
	}

	public void cancelOrder() {
		setNumItems(0);
	}

	public double getTotalCost() {
		return(getNumItems() * getUnitCost());
	}
}
