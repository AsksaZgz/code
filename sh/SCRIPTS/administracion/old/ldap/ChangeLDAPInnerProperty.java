
import java.util.*;

import javax.naming.*;
import javax.naming.directory.*;
import javax.naming.ldap.*;

public class ChangeLDAPInnerProperty
{
  public static String INITCTX = "com.sun.jndi.ldap.LdapCtxFactory";
  public static String HOST = "ldap://localhost:389";
  public static String MGR_DN = "dc=com";
  public static String MGR_PW = "---";

  public static void main(String args[])
  {
    if (args.length == 3)
    {
      String baseName = args[0];
      String property = args[1];
      String value    = args[2];
    
      try 
      {
      
        Hashtable env = new Hashtable();
         
        env.put(Context.INITIAL_CONTEXT_FACTORY, INITCTX);
                                    
        env.put(Context.PROVIDER_URL, HOST);
                                             
        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, MGR_DN);
// Pendiente de contrasenia        
//        env.put(Context.SECURITY_CREDENTIALS, MGR_PW);    
        LdapContext ctx = new InitialLdapContext(env, null);
    
        SearchControls constraints = new SearchControls();
        constraints.setSearchScope(SearchControls.OBJECT_SCOPE);
        
        NamingEnumeration answer = ctx.search(baseName, "(objectClass=*)", constraints);
    
        while (answer.hasMore()) 
        {
          SearchResult sr = (SearchResult)answer.next();
          Attributes attrs = sr.getAttributes();
          for (NamingEnumeration ne = attrs.getAll(); ne.hasMoreElements();)
          {
            Attribute attr = (Attribute) ne.next();
            String attrID = attr.getID();
                                            
            if (attrID.equals("property"))
            {
              Enumeration vals = attr.getAll();
              if (vals.hasMoreElements())
              {
                String str = (String) vals.nextElement();
                if (str != null)
                {
                  System.out.println("changing:\n" + str);
                  str = "::" + str;
                  int pos = str.indexOf("::" + property + "=");
                  if (pos != -1)
                  {
                    String res = str.substring(0, pos + 2) + property + "=" + value;
                    int posEnd = str.indexOf("::", pos + 2);
                    if (posEnd != -1)
                      res += str.substring(posEnd);
                      
                    // Quitamos los dos puntos que habiamos aniadido
                    res = res.substring(2);
                    System.out.println("to      :\n" + res);
                    
                    ModificationItem[] mods = new ModificationItem[1];
                    
                    attr = new BasicAttribute("property", res);
                    mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, attr);
                    ctx.modifyAttributes(baseName, mods);
                  }
                  else
                    System.out.println("No changes made.");
                }
              }
            }
          }
        }
        
      }
      catch (NamingException e) 
      {
        e.printStackTrace();
      }
    }
    else
    {
      System.out.println("usage: ChangeLdapInnerProperty <base_search> <inner_property> <value>");
    }
  }
}