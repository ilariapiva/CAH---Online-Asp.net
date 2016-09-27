<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" %>
<%@ MasterType  virtualPath="~/MasterPage.master"%>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="CAHOnline" %>

<script runat="server">

    String email, user, pwd;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (FunctionsDB.ExistCookies())
        {
            Room room = new Room();
            if (room.ExistUserInRoom(Master.resultUser))
            {
                int indexRoom = room.ReturnKeyRoomUser(Master.resultUser);
                FunctionsDB.UpdateUserExit(Master.resultUser);

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
                    FunctionsDB.DeleteUserInGame(Master.resultUser);
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
            Response.Redirect("~/signUp.aspx");
        }
    }
    
    protected void btnRegister_Click(object sender, EventArgs e)
    {
        email = "";
        user = "";
        pwd = "";

        email = txtEmail.Text;
        pwd = txtPassword.Text;
        user = txtUsername.Text;

        if (FunctionsDB.CeckEmail(email))//Controllo che l'email inserita non sia già utilizzata da altri utenti 
        {
            //lblEmailUse.Text = "Questo indirizzo email è già utilizzato.";
            lblEmailUse.Text = "This e-mail has been used.";
        }

        if (FunctionsDB.CeckUsername(user))//Controllo che lo username inserito non sia già utilizzata da altri utenti 
        {
            lblUser.Text = "This username has been used by someone else.";
        }

        if ((FunctionsDB.CeckEmail(email) == false) && (FunctionsDB.CeckUsername(user) == false))//Inserisco il nuovo account nella tabella account
        {
            FunctionsDB.RegisterUser(email, user, pwd);
            Response.Redirect("~/login.aspx");
        }
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link rel="stylesheet" type="text/css" href="css/Cards.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h2 class="h1-text">Sign Up</h2>
                <%-- <h6 class="h6-text">Registrati per iniziare a giocare alla versione online di
                    <br />
                    Cards Against Humanity!</h6>--%>
                <h6 class="h6-text">Sign Up to start playing the online version of
                    <br />
                    Cards Against Humanity!</h6>
                <div style="margin-top: 75px">
                    <asp:Label ID="lblEmail" runat="server" Text="E-mail address:" CssClass="profile-x email"></asp:Label>
                    <asp:TextBox ID="txtEmail" placeholder="Email" runat="server" Width="400px" ForeColor="White" />
                    <%--<asp:RegularExpressionValidator ID="revEmail" runat="server" ErrorMessage="Sintassi email non valida" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail" ForeColor="#FF3300" />--%>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="X" ValidationExpression=".*@.*\..*" ControlToValidate="txtEmail" ForeColor="#FF3300" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtEmail" ErrorMessage="X" runat="server" ForeColor="#FF3300" />
                </div>
                <asp:Label ID="lblEmailUse" runat="server" class="info-error" ForeColor="#FF3300"></asp:Label>
                <div>
                    <asp:Label ID="lblUsername" runat="server" Text="Username:" CssClass="profile-x username"></asp:Label>
                    <asp:TextBox ID="txtUsername" placeholder="Username" runat="server" Width="400px" ForeColor="White" />
                    <asp:RequiredFieldValidator class="info-error" ID="RequiredFieldValidator1" ControlToValidate="txtUsername" Display="Dynamic" ErrorMessage="X" runat="server" ForeColor="#FF3300" />
                </div>
                <asp:Label ID="lblUser" runat="server" class="info-error" ForeColor="#FF3300"></asp:Label>
                <div style="margin-top: 25px">
                    <asp:Label ID="lblPassword" runat="server" Text="Password:" CssClass="profile-x password"></asp:Label>
                    <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Password" runat="server" Width="400px" ForeColor="White" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtPassword" ErrorMessage="X" runat="server" ForeColor="#FF3300" />
                </div>
                <div style="margin-top: 25px">
                    <asp:LinkButton ID="btnRegister" runat="server" CssClass="btn waves-effect waves-light btn-x" OnClick="btnRegister_Click">Sign Up<i class="material-icons right">send</i></asp:LinkButton>
                    <asp:Label ID="lblMsg" ForeColor="#FF3300" runat="server" />
                </div>
            </div>
            <div class="position">
                <ul id="index_cards">
                    <li id="card-1" class="empty-cards black">
                        <p class="p-cards">
                            Money can't buy my<br />
                            love, but it can buy<br />
                            me ___________.
                        </p>
                    </li>
                    <li id="card-2" class="empty-cards white">
                        <p class="p-cards">
                            A sad fat dragon<br />
                            with no firends.
                        </p>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</asp:Content>