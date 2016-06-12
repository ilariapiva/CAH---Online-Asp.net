﻿<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    Account userEmail;
    String pwd, email;

    protected void Page_Load(object sender, EventArgs e)
    {
        //FunctionsDB.OpenConnectionDB();
    }
    protected void btnLogin_Click1(object sender, EventArgs e)
    {
        userEmail = new Account();
        email = "";
        pwd = "";

        email = txtEmail.Text;
        pwd = txtPassword.Text;

        //Controllo che l'email e la pwd corrispondano ad uno user registrato e poi memorizzo tramite i cookies l'email e accedo alla pagina principale
        if (FunctionsDB.Login(email, pwd))
        {
            FunctionsDB.CookiesResponse(userEmail);//Memorizzo l'email nei cookies
           
            FormsAuthentication.RedirectFromLoginPage(userEmail.Email, CheckBoxRemember.Checked);
            Response.Redirect("~/index.aspx");
        }
        else
        {
            lblMsg.Text = "Invalid credentials. Please try again.";
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
                                <asp:Label ID="lblPassword" runat="server" Text="Password:" ForeColor="White" CssClass="password"></asp:Label>
                                <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" Width="400px" ForeColor="White" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtPassword" ErrorMessage="Cannot be empty." runat="server" ForeColor="#FF3300" />
                            </div>
                            <div style="margin-top: 25px">
                                <asp:Label ID="lblResetPwd" runat="server" Text="Hai dimenticato la password?" ForeColor="White"></asp:Label>
                                <asp:HyperLink ID="HyperLinkResetPwd" runat="server" NavigateUrl="~/resetPassword.aspx" ForeColor="White">Clicca qui.</asp:HyperLink>   
                            </div>
                            <div style="margin-top: 25px">
                                <asp:LinkButton ID="btnLogin" runat="server" CssClass="btn waves-effect waves-light btn-x" OnClick="btnLogin_Click1">Login<i class="material-icons right">send</i></asp:LinkButton>
                                <asp:Label ID="lblMsg" ForeColor="#FF3300" runat="server" />
                                <asp:Label ID="lblRemember" ForeColor="White" runat="server" Text="Remember me?" />
                                <asp:CheckBox ID="CheckBoxRemember" runat="server" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>