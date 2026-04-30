// dto/RegisterRequest.java
package apash.coding.sa.dto;

public class RegisterRequest {
    private String name;
    private String email;
    private String telephone;
    private String profil;
    private String password;

    public RegisterRequest() {}

    // Getters & Setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getProfil() { return profil; }
    public void setProfil(String profil) { this.profil = profil; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}