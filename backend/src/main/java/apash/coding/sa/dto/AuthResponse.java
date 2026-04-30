// dto/AuthResponse.java  ← ce que le backend renvoie au Flutter
package apash.coding.sa.dto;


public class AuthResponse {
    private Integer id;  
    private String token;
    private String email;
    private String name;

    public AuthResponse(Integer id, String token, String email, String name) {
        this.id = id;
        this.token = token;
        this.email = email;
        this.name = name;
    }

    public Integer getId() { return id; }
    public String getToken() { return token; }
    public String getEmail() { return email; }
    public String getName() { return name; }
}