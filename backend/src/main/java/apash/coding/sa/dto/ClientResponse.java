// dto/ClientResponse.java  ← profil sans le password !
package apash.coding.sa.dto;

public class ClientResponse {
    private Integer id;
    private String name;
    private String email;
    private String telephone;
    private String profil;

    public ClientResponse(Integer id, String name, String email,
                          String telephone, String profil) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.telephone = telephone;
        this.profil = profil;
    }

    public Integer getId() { return id; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getTelephone() { return telephone; }
    public String getProfil() { return profil; }
}