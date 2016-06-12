<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    String email, user, pwd;

    protected void Page_Load(object sender, EventArgs e)
    {
        //FunctionsDB.OpenConnectionDB();
    }

    protected void btnRegister_Click1(object sender, EventArgs e)
    {
        lblEmail.Text = "";
        lblUser.Text = "";

        email = "";
        user = "";
        pwd = "";

        email = txtEmail.Text;
        pwd = txtPassword.Text;
        user = txtUsername.Text;

        if (FunctionsDB.CeckEmail(email))//Controllo che l'email inserita non sia già utilizzata da altri utenti 
        {
            lblEmail.Text = "Questo indirizzo email è già utilizzato.";
        }

        if (FunctionsDB.CeckUsername(user))//Controllo che lo username inserito non sia già utilizzata da altri utenti 
        {
            lblUser.Text = "Questo username è già utilizzato.";
        }

        if ((FunctionsDB.CeckEmail(email) == false) && (FunctionsDB.CeckUsername(user) == false))//Inserisco il nuovo account nella tabella account
        {
            FunctionsDB.RegisterUser(email, user, pwd);
            Response.Redirect("~/login.aspx");
        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="row">
            <div class="col-md-8">
                <div class="row">
                    <div class="col-md-16">
                        <div class="card-panel-x">
                            <h5 class="h5-text">Il famoso gioco di carte Cards Against Humanity in versione Online.</h5>
                            <div style="margin-top: 75px">
                                <asp:Label ID="lblEmail" runat="server" Text="E-mail address:" ForeColor="White" CssClass="email"></asp:Label>
                                <asp:TextBox ID="txtEmail" placeholder="Email" runat="server" Width="400px" ForeColor="White" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ErrorMessage="Sintassi email non valida" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail" ForeColor="#FF3300" />
                            </div>
                             <div style="margin-top: 25px">
                                 <asp:Label ID="lblUsername" runat="server" Text="Username:" CssClass="username" ForeColor="White"></asp:Label>
                                 <asp:TextBox ID="txtUsername" placeholder="Username" runat="server" Width="400px" ForeColor="White" />
                                <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator1" ControlToValidate="txtUsername" Display="Dynamic" ErrorMessage="Cannot be empty." runat="server" />
                                <asp:Label ID="lblUser" runat="server" class="info-error"></asp:Label> 
                            </div>
                            <div style="margin-top: 25px">
                                <asp:Label ID="lblPassword" runat="server" Text="Password:" ForeColor="White" CssClass="password"></asp:Label>
                                <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" Width="400px" ForeColor="White" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtPassword" ErrorMessage="Cannot be empty." runat="server" ForeColor="#FF3300" />
                            </div>
                            <div style="margin-top: 25px">
                                <asp:LinkButton ID="btnRegister" runat="server" CssClass="btn waves-effect waves-light btn-x" OnClick="btnRegister_Click1">Sign In<i class="material-icons right">send</i></asp:LinkButton>
                                <asp:Label ID="lblMsg" ForeColor="#FF3300" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>