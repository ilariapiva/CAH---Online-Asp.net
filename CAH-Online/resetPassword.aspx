<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    String pwd, email;

    protected void Page_Load(object sender, EventArgs e)
    {
        //FunctionsDB.OpenConnectionDB();
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        email = txtEmail.Text;
        pwd = txtPassword.Text;

        if (FunctionsDB.ResetPwd(email, pwd))
        {
            Response.Redirect("~/login.aspx");
        }
        else
        {
            lblMsg.Text = "Invalid credentials. Please try again.";
        }
    }
</script>
<script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>

<html>
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link href="css/bootstrap.min.css" rel="stylesheet" />
    <link href="css/bootstrap.css.map" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet" />
    <link rel="stylesheet" type="text/css" href="css/Style.css" />
    <link rel="stylesheet" type="text/css" href="css/bootstrap.min.css" />
    <title>CAH - Online</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="flat-form">
                <ul class="tabs">
                    <li>
                        <asp:HyperLink runat="server" NavigateUrl="~/login.aspx" CssClass="active">Login</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink runat="server" NavigateUrl="~/register.aspx">Register</asp:HyperLink></li>
                    <li>
                        <asp:HyperLink runat="server" NavigateUrl="~/resetPassword.aspx">Reset password</asp:HyperLink></li>
                </ul>
                <div class="form-action show">
                    <h1>CAH - Online</h1>
                    <p>Il famoso gioco di carte Cards Against Humanity in versione Online.</p>
                    <div>
                        <ul class="ul-style">
                            <li>E-mail address:
                                <asp:TextBox ID="txtEmail" placeholder="Email" runat="server" />
                                <%--<asp:RegularExpressionValidator class="info-error" ID="revEmail" runat="server" ErrorMessage="Sintassi email non valida" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail"/>--%>
                            </li>
                        </ul>
                        <ul class="ul-style">
                            <li>Password:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" />
                                <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator2" ControlToValidate="txtPassword" ErrorMessage="Cannot be empty." runat="server" />
                            </li>
                        </ul>

                    </div>
                    <div class="div-btn">
                        <asp:Button ID="btnReset" class="button" Text="Reset password" runat="server" OnClick="btnReset_Click" Width="114px" />
                    </div>
                    <p>
                        <asp:Label ID="lblMsg" ForeColor="Red" runat="server" />
                    </p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
