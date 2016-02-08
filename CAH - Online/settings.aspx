
<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script runat="server">
        
        protected void Page_Load(object sender, EventArgs e)
        {
            lblEmail.Text = Session["userEmail"].ToString();
        }
        
        void btnSalva_Click(object sender, EventArgs e)
        {
            lblUser.Text = "";

            var pwd = UserPass.Text;
            Account user = new Account();
            user.Username = UserName.Text;

            //Controllo che il username scelto non sia già utilizzato da altri utenti
            String strsqlUser = "SELECT username FROM tblAccount WHERE username = '" + user.Username + "'";
            bool result = FunctionsDB.CheckDB(strsqlUser);

            if (result)
            {
                lblUser.Text = "Questo username è già utilizzato.";
            }

            //Se il nome utente non è già stato utilizzato eseguo la query che modifica lo username e la password
            if (result == false)
            {
                strsqlUser = "UPDATE tblAccount SET username = '" + user.Username + "' WHERE email = '" + Session["userEmail"] + "' ";
                FunctionsDB.WriteDB(strsqlUser);

                String strsqlPwd = "UPDATE tblAccount SET pwd = HASHBYTES('SHA1', '" + pwd + "') WHERE email = '" + Session["userEmail"] + "' ";
                FunctionsDB.WriteDB(strsqlPwd);

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
                            <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator3" ControlToValidate="UserName" Display="Dynamic" ErrorMessage="Cannot be empty." runat="server" />
                            <asp:Label ID="lblUser" runat="server" class="info-error"></asp:Label>
                        </li>
                    </ul>
                    <ul>
                        <li>Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:TextBox ID="UserPass" TextMode="Password" placeholder="Password" runat="server" />
                            <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator5" ControlToValidate="UserPass" ErrorMessage="Cannot be empty." runat="server" />
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
