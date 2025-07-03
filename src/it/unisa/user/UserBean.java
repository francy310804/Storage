package it.unisa.user;

public class UserBean {
	String nome, cognome, email, citta, provincia, password, indirizzo, ruolo;
	int cap, id;
	
	public UserBean() {
		this.id = -1;
		this.nome = null;
		this.cognome = null;
		this.email = null;
		this.citta = null;
		this.provincia = null;
		this.password = null;
		this.indirizzo = null;
		this.cap = 0;
		this.ruolo = null;
		
	}
	
	public UserBean(String nome, String cognome, String email, String citta, String provincia, String password,
			String indirizzo, int cap) {
		super();
		this.nome = nome;
		this.cognome = cognome;
		this.email = email;
		this.citta = citta;
		this.provincia = provincia;
		if(password != null) //Se la pass non è nulla la setta
			this.password = password;
		
		this.indirizzo = indirizzo;
		this.cap = cap;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public int getId() {
		return this.id;
	}
	
	public String getNome() {
		return nome;
	}
	
	public String getIndirizzo() {
		return indirizzo;
	}
	
	public String getRuolo() {
		return ruolo;
	}
	
	public void setRuolo(String ruolo) {
		this.ruolo = ruolo;
	} 
	
	public void setIndirizzo(String indirizzo) {
		this.indirizzo = indirizzo;
	}
	
	public void setNome(String nome) {
		this.nome = nome;
	}
	
	public String getCognome() {
		return cognome;
	}
	
	public void setCognome(String cognome) {
		this.cognome = cognome;
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getCitta() {
		return citta;
	}
	
	public void setCitta(String citta) {
		this.citta = citta;
	}
	
	public String getProvincia() {
		return provincia;
	}
	
	public void setProvincia(String provincia) {
		this.provincia = provincia;
	}
	
	public String getPassword() {
		return password;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
	
	public int getCap() {
		return cap;
	}
	
	public void setCap(int cap) {
		this.cap = cap;
	}

	@Override
	public String toString() {
		return "UserBean [id = " + id + ", nome=" + nome + ", cognome=" + cognome + ", email=" + email + ", citta=" + citta
				+ ", provincia=" + provincia + ", password=" + password + ", cap=" + cap + " indirizzo= " + indirizzo + "]";
	}
	
	

}
