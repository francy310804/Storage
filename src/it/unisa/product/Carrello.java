package it.unisa.product;

import java.util.ArrayList;
import java.util.List;

public class Carrello {
	private List<ProductBean> prodotti;
	
	public Carrello () {
		prodotti = new ArrayList<ProductBean>();
	}
	
	public void addCarrello(ProductBean bean) {
		prodotti.add(bean);
	}
	
	public void deleteCarrello(ProductBean bean) {
		for(ProductBean beanC : prodotti) {
			if(beanC.getIdProdotto() == bean.getIdProdotto())
				prodotti.remove(beanC);
			break;
		}
	}
	
	public List<ProductBean> getProdotti(){
		return prodotti;
	}
}
