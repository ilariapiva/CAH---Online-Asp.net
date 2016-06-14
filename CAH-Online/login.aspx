<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    Account userEmail;
    String pwd, email;
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (FunctionsDB.ExistCookies())
        {
            Room room = new Room();
            if (room.ExistUserInRoom(Master.resultUser))
            {
                int indexRoom = room.ReturnKeyRoomUser(Master.resultUser);

                if (room.CheckDeleteCardsUser(Master.resultUser))
                {
                    room.DeleteCardsUser(Master.resultUser);
                }
                if (room.CheckDeleteUser(indexRoom, Master.resultUser))
                {
                    room.DeleteUser(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckUserInGame(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteUserInGame(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckCardsUser(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteCardSelectUser(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckDeleteCardsWhite(indexRoom, Master.resultUser))
                {
                    FunctionsDB.DeleteCardsWhite(indexRoom, Master.resultUser);
                }
                if (FunctionsDB.CheckDeleteCardsBlack(indexRoom))
                {
                    FunctionsDB.DeleteCardsBlack(indexRoom);
                }
            }
            FunctionsDB.DeleteCookies(Master.resultUser);
            Response.Redirect("~/login.aspx");
        }
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
            userEmail.Email = txtEmail.Text;

            //FunctionsDB.WriteCookie(userEmail);
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
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link rel="stylesheet" type="text/css" href="css/Cards.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h2 class="h1-text">Log In</h2>
                <%--<h6 class="h6-text">Accedi per iniziare a giocare alla versione online di <br /> Cards Against Humanity!</h6>--%>
                <h6 class="h6-text">Log In to start playing the online version of<br />
                    Cards Against Humanity!</h6>
                <div style="margin-top: 75px">
                    <asp:Label ID="lblEmail" runat="server" Text="E-mail address:" CssClass="profile-x email"></asp:Label>
                    <asp:TextBox ID="txtEmail" placeholder="Email" runat="server" Width="400px" ForeColor="White" />
                    <%--<asp:RegularExpressionValidator ID="revEmail" runat="server" ErrorMessage="Sintassi email non valida" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail" ForeColor="#FF3300" />--%>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="X" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail" ForeColor="#FF3300" Font-Bold="True" Font-Size="Larger" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtEmail" ErrorMessage="X" runat="server" ForeColor="#FF3300" />
                </div>
                <div style="margin-top: 25px">
                    <asp:Label ID="lblPassword" runat="server" Text="Password:" CssClass="profile-x password"></asp:Label>
                    <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" Width="400px" ForeColor="White" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtPassword" ErrorMessage="X" runat="server" ForeColor="#FF3300" />
                </div>
                <div style="margin-top: 25px">
                    <asp:CheckBox ID="CheckBoxRemember" runat="server" Text="Remember me." CssClass="checkRemember" ForeColor="White" />
                    <asp:Label ID="lblResetPwd" runat="server" Text="Did you forget your password?" CssClass="reset"></asp:Label>
                    <asp:HyperLink ID="HyperLinkResetPwd" runat="server" NavigateUrl="~/resetPassword.aspx" ForeColor="White">Click here.</asp:HyperLink>
                </div>
                <div style="margin-top: 25px">
                    <asp:LinkButton ID="btnLogin" runat="server" CssClass="btn waves-effect waves-light btn-x" OnClick="btnLogin_Click1">Log In<i class="material-icons right">send</i></asp:LinkButton>
                    
                </div>
                <asp:Label ID="lblMsg" ForeColor="#FF3300" runat="server" />
            </div>
            <div class="position">
                <div id="wrapper">
                    <ul id="index_cards">
                        <li id="card-1" class="empty-cards black">
                            <p class="p-cards">
                                And the
                                <br />
                                Academy Award<br />
                                for _________<br />
                                goes to _________.
                            </p>
                        </li>
                        <li id="card-2" class="empty-cards white">
                            <p class="p-cards">
                                A bag of magic <br />
                                beans.
                            </p>
                        </li>
                        <li id="card-10" class="empty-cards white">
                             <p class="p-cards">
                                Barack Obama.
                            </p>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
