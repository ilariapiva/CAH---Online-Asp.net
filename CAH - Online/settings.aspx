
<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
<script runat="server">
        
    String pwd, user;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        //FunctionsDB.OpenConnectionDB();
        
        lblEmail.Text = Session["userEmail"].ToString();
    }
        
    void btnSalva_Click(object sender, EventArgs e)
    {
        lblUser.Text = "";

        pwd = "";
        user = "";
        
        pwd = UserPass.Text;
        user = UserName.Text;

        if (FunctionsDB.CeckUsername(user))//Controllo che il username scelto non sia già utilizzato da altri utenti
        {
            lblUser.Text = "Questo username è già utilizzato.";
        }

        if (FunctionsDB.CeckUsername(user) == false & UserPass.Text == "")//Se il nome utente non è già stato utilizzato e la texPwd è vuota eseguo la funzione ChangeUsername
        {
            FunctionsDB.ChangeUsername(user);
            Response.Redirect("~/index.aspx");
        }

        if(UserName.Text == "")//Se la textUsername è vuota eseguo il ChangePwd
        {
            FunctionsDB.ChangePwd(pwd);
            Response.Redirect("~/index.aspx");
        }

        if (FunctionsDB.CeckUsername(user) == false)//Se il nome utente non è già stato utilizzato e la textUsername non è vuota eseguo la funzione ChangeUsername e ChangePwd 
        {
            FunctionsDB.ChangeUsername(user);
            FunctionsDB.ChangePwd(pwd);
            Response.Redirect("~/index.aspx");
        }
    }
</script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="flat-form-setting">
            <div class="form-action-setting">
                <h1 class="h1">Settings</h1>
                <p class="p5">
                    Qui puoi modificare il tuo username e la password.
                </p>
                <p class="p5">
                    <br />
                </p>
                <div>
                    <ul>
                        <li>E-mail address:
                            <asp:Label ID="lblEmail" class="label-form" runat="server"></asp:Label>
                        </li>
                    </ul>
                    <ul>
                        <li>Username:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:TextBox ID="UserName" placeholder="Username" runat="server" />
                            <!--<asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator3" ControlToValidate="UserName" Display="Dynamic" ErrorMessage="Cannot be empty." runat="server" />-->
                            <asp:Label ID="lblUser" runat="server" class="info-error"></asp:Label>
                        </li>
                    </ul>
                    <ul>
                        <li>Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:TextBox ID="UserPass" TextMode="Password" placeholder="Password" runat="server" />
                            <!--<asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator5" ControlToValidate="UserPass" ErrorMessage="Cannot be empty." runat="server" />-->
                        </li>
                        <li></li>
                    </ul>
                </div>
                <div>
                    <asp:Button ID="btnSalva" class="button" Text="Salva" OnClick="btnSalva_Click" runat="server" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
